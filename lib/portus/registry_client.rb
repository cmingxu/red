module Portus
  # RegistryClient is a a layer between Portus and the Registry. Given a set of
  # credentials, it's able to call to any endpoint in the registry API. Moreover,
  # it also implements some handy methods on top of some of these endpoints (e.g.
  # the `manifest` method for the Manifest API endpoints).
  module HttpHelpers
    # As specified in the token specification of distribution, the client will
    # get a 401 on the first attempt of logging in, but in there should be the
    # "WWW-Authenticate" header. This exception will be raised when there's no
    # authentication token bearer.
    class NoBearerRealmException < RuntimeError; end

    # Raised when the authorization token could not be fetched.
    class AuthorizationError < RuntimeError; end

    # Used when a resource was not found for the given endpoint.
    class NotFoundError < RuntimeError; end

    # Raised if this client does not have the credentials to perform an API call.
    class CredentialsMissingError < RuntimeError; end

    # This is the general method to perform an HTTP request to an endpoint
    # provided by the registry. The first parameter is the URI of the endpoint
    # itself. The second parameter is the HTTP method in downcase (e.g. "post").
    # It defaults to "get", which is what we usually perform in this application.
    # The `request_auth_token` parameter means that if this method gets a 401
    # when calling the given path, it should get an authorization token
    # automatically and try again.
    def perform_request(path, method = "get", request_auth_token = true)
      uri = URI.join(@base_url, path)
      req = Net::HTTP.const_get(method.capitalize).new(uri)

      # So we deal with compatibility issues in distribution 2.3 and later.
      # See: https://github.com/docker/distribution/blob/master/docs/compatibility.md#content-addressable-storage-cas
      req["Accept"] = "application/vnd.docker.distribution.manifest.v2+json"

      # This only happens if the auth token has already been set by a previous
      # call.
      req["Authorization"] = "Bearer #{@token}" if @token

      res = get_response_token(uri, req)
      if res.code.to_i == 401
        # This can mean that this is the first time that the client is calling
        # the registry API, and that, therefore, it might need to request the
        # authorization token first.
        if request_auth_token
          # Note that request_auth_token will raise an exception on error.
          request_auth_token(res)
          # Recursive call, but this time we make sure that we don't enter here
          # again. If this call fails, then there's something *really* wrong with
          # the given credentials.
          return perform_request(path, method, false)
        end
      end

      res
    end

    # Handle a known error from Docker distribution. Typically these are
    # responses that have an HTTP code of 40x. The given response is the raw
    # response as given by the registry, and the params hash are extra arguments
    # that will be passed to the exception message.
    def handle_error(response, params = {})
      str = "\nCode: #{response.code}\n"

      # Add the errors as given by the registry.
      begin
        body = JSON.parse(response.body)
        if body["errors"]
          str += "Reported by Registry:\n"
          body["errors"].each { |err| str += "#{err}\n" }
          str += "\n"
        end
      rescue JSON::ParserError
        str += "Body:\n#{response.body}\n\n"
      end

      # Add the defined parameters.
      unless params.empty?
        str += "Passed values:\n"
        params.each { |k, v| str += "#{k}: #{v}\n" }
        str += "\n"
      end

      raise NotFoundError, str
    end

    private

    # Returns true if this client has the credentials set.
    def credentials?
      @username && @password
    end

    # This method should be called after getting a 401. In this case, the
    # registry has sent the proper "WWW-Authenticate" header value that will
    # allow us the request a new authorization token for this client.
    def request_auth_token(unhauthorized_response)
      bearer_realm, query = parse_unhauthorized_response(unhauthorized_response)
      uri = URI("#{bearer_realm}?#{query.to_query}")

      req = Net::HTTP::Get.new(uri)
      req.basic_auth(@username, @password) if credentials?

      res = get_response_token(uri, req)
      if res.code.to_i == 200
        @token = JSON.parse(res.body)["token"]
      else
        @token = nil
        raise AuthorizationError, "Cannot obtain authorization token: #{res}"
      end
    end

    # For the given 401 response, try to extract the token and the parameters
    # that this client should use in order to request an authorization token.
    def parse_unhauthorized_response(res)
      auth_args = res.to_hash["www-authenticate"].first.split(",").each_with_object({}) do |i, h|
        key, val = i.split("=")
        h[key] = val.delete('"')
      end

      unless credentials?
        raise CredentialsMissingError, "Registry #{@host} has authorization enabled, "\
          "user credentials not specified"
      end

      query_params = {
        "service" => auth_args["service"],
        "account" => @username
      }
      query_params["scope"] = auth_args["scope"] if auth_args.key?("scope")

      unless auth_args.key?("Bearer realm")
        raise(NoBearerRealmException, "Cannot find bearer realm")
      end

      [auth_args["Bearer realm"], query_params]
    end

    # Performs an HTTP request to the given URI and request object. It returns an
    # HTTP response that has been sent from the registry.
    def get_response_token(uri, req)
      options = { use_ssl: uri.scheme == "https", open_timeout: 20,
                  :verify_mode => OpenSSL::SSL::VERIFY_NONE
      }

      if uri.hostname =~ /ngrok/ # hack
        req = Net::HTTP::Get.new URI.parse("http://localhost:3000" + req.path)
        req.basic_auth(@username, @password) if credentials?
        Net::HTTP.start("localhost", 3000, options) do |http|
          http.request(req)
        end
      else
        Net::HTTP.start(uri.hostname, uri.port, options) do |http|
          http.request(req)
        end
      end
    end
  end

  class RegistryClient
    include HttpHelpers

    # Exception being raised when we get an error from the Registry API that we
    # don't know how to handle.
    class RegistryError < StandardError; end

    # Initialize the client by setting up a hostname and the user. Note that if
    # no user was given, the "portus" special user is assumed.
    def initialize(host, use_ssl = false, username = nil, password = nil)
      @host     = host
      @use_ssl  = use_ssl
      @base_url = "http#{"s" if @use_ssl}://#{@host}/v2/"
      @username = username
      @password = password
    end

    # Returns whether the registry is reachable with the given credentials or
    # not.
    def reachable?
      res = perform_request("", "get", false)

      # If a 401 was retrieved, it means that at least the registry has been
      # contacted. In order to get a 200, this registry should be created and
      # an authorization requested. The former can be inconvenient, because we
      # might want to test whether the registry is reachable.
      !res.nil? && res.code.to_i == 401
    end

    # Calls the `/:repository/manifests/:tag` endpoint from the registry. It
    # returns a three-sized array:
    #
    #   - The image ID (without the "sha256:" prefix): only available for v2
    #     manifests (nil if v1).
    #   - The manifest digest.
    #   - The manifest itself as a ruby hash.
    #
    # It will raise either a ManifestNotFoundError or a RuntimeError if
    # something goes wrong.
    def manifest(repository, tag = "latest")
      res = perform_request("#{repository}/manifests/#{tag}", "get")

      if res.code.to_i == 200
        mf = JSON.parse(res.body)
        id = mf.try(:[], "config").try(:[], "digest")
        id = id.split(":").last if id.is_a? String
        digest = res["Docker-Content-Digest"]
        [id, digest, mf]
      elsif res.code.to_i == 404
        handle_error res, repository: repository, tag: tag
      else
        raise "Something went wrong while fetching manifest for " \
          "#{repository}:#{tag}:[#{res.code}] - #{res.body}"
      end
    end

    def blobs(repository, digest = "latest")
      res = perform_request("#{repository}/blobs/#{digest}", "get")

      if res.code.to_i == 200
        puts res.body
        mf = JSON.parse(res.body)
        id = mf.try(:[], "config").try(:[], "digest")
        id = id.split(":").last if id.is_a? String
        digest = res["Docker-Content-Digest"]
        [id, digest, mf]
      elsif res.code.to_i == 404
        handle_error res, repository: repository, digest: digest
      else
        raise "Something went wrong while fetching manifest for " \
          "#{repository}:#{tag}:[#{res.code}] - #{res.body}"
      end
    end

    # Fetches all the repositories available in the registry, with all their
    # corresponding tags. If something goes wrong while fetching the repos from
    # the catalog (e.g. authorization error), it will raise an exception.
    #
    # Returns an array of hashes which contain two keys:
    #   - name: a string containing the name of the repository.
    #   - tags: an array containing the available tags for the repository.
    def catalog
      res = paged_response("_catalog", "repositories")
      add_tags(res)
    end

    # Returns an array containing the list of tags. If something goes wrong,
    # then it raises an exception.
    def tags(repository)
      paged_response("#{repository}/tags/list", "tags")
    end

    # Deletes a blob/manifest of the specified image. Returns true if the
    # request was successful, otherwise it raises an exception.
    def delete(name, digest, object = "blobs")
      res = perform_request("#{name}/#{object}/#{digest}", "delete")
      if res.code.to_i == 202
        true
      elsif res.code.to_i == 404 || res.code.to_i == 405
        handle_error res, name: name, digest: digest
      else
        raise ::Portus::RegistryClient::RegistryError,
          "Something went wrong while deleting blob: " \
          "[#{res.code}] - #{res.body}"
      end
    end

    protected

    # Returns all the items that could be extracted from the given link that
    # are indexed by the given field in a successful response. If anything goes
    # wrong, it raises an exception.
    def paged_response(link, field)
      res = []
      link += "?n=100"

      until link.empty?
        page, link = get_page(link)
        next unless page[field]
        res += page[field]
      end
      res
    end

    # Fetches the next page from the provided link. On success, it will return
    # an array of the items:
    #   - The parsed response body.
    #   - The link to the next page.
    # On error it will raise the proper exception.
    def get_page(link)
      res = perform_request(link)
      if res.code.to_i == 200
        [JSON.parse(res.body), fetch_link(res["link"])]
      elsif res.code.to_i == 404
        handle_error res
      else
        raise ::Portus::RegistryClient::RegistryError,
          "Something went wrong while fetching the catalog " \
          "Response: [#{res.code}] - #{res.body}"
      end
    end

    # Fetch the link to the next catalog page from the given response.
    def fetch_link(header)
      return "" if header.blank?
      link = header.split(";")[0]
      link.strip[1, link.size - 2]
    end

    # Adds the available tags for each of the given repositories. If there is a
    # problem while fetching a repository's tag, it will return an empty array.
    # Otherwise it will return an array with the results as specified in the
    # documentation of the `catalog` method.
    def add_tags(repositories)
      return [] if repositories.nil?

      result = []
      repositories.each do |repo|
        begin
          ts = tags(repo)
          result << { "name" => repo, "tags" => ts } unless ts.blank?
        rescue StandardError => e
          Rails.logger.debug "Could not get tags for repo: #{repo}: #{e.message}."
        end
      end
      result
    end
  end
end
