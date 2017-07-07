require 'httparty'
require 'uri'

module Clair
  class HttpRequestException < Exception ; end
  class ClairRequestException < Exception ; end

  module Base
    VERSION = "/v1"
    DEFAULT_HEADER =  {
        headers: {
          "User-Agent" => "Clair Client",
          "Content-Type" => "application/json",
          "Accept" => "application/json",
        }
    }

    attr_accessor :clair_base_url, :registry_base_url, :token_path, :username, :password

    def clair_base
      (@clair_base_url || "https://clair.hengdingsheng.com")
    end

    def registry_base
      (@registry_base_url || "https://registry.hengdingsheng.com")
    end

    def do_get path, query={}, options= {}
      options.merge!(DEFAULT_HEADER)

      begin
        uri = URI.join(self.clair_base, VERSION + path)
        uri.query = query.to_query if query.present?

        JSON.parse(HTTParty.get(uri.to_s, options).body)
      rescue Exception => e
        raise HttpRequestException.new(e)
      end
    end

    def do_post path, body, options={}
      options.merge!(DEFAULT_HEADER)

      begin
        resp = HTTParty.post URI.join(self.clair_base, VERSION + path).to_s, body: body.to_json
      rescue Exception => e
        raise HttpRequestException.new(e)

        if resp.code != 201
          raise ClairRequestException.new(resp.body)
        end
      end
    end

    def do_delete path, query = {}, options = {}
      begin
        HTTParty.delete URI.join(self.clair_base, path), options
      rescue Exception => e
        raise HttpRequestException.new(e)
      end
    end

    def get_bear_token name
      resp = HTTParty.get @token_path + "?account=#{@username}&service=registry&offline_token=true&client_id=clair&scope=repository:#{name}:pull", basic_auth: {username: @username, password: @password}
      resp['token']
    end

    module_function :clair_base_url=, :do_get, :do_post, :do_delete, :clair_base, :registry_base,
      :token_path=, :username=, :password=, :get_bear_token, :registry_base_url=
  end
end
