require 'portus'

class RegistryController < ApplicationController
  skip_before_action :login_required, :set_page_request_meta_info, :set_locale
  skip_before_action :verify_authenticity_token


  def notifications
    events_body = JSON.parse(request.raw_post)

    Namespace.from_notifications(events_body['events']) if events_body['events'].present?
    head :ok
  end

  # Returns the token that the docker client should use in order to perform
  # operation into the private registry.
  def token
    ap request.path
    token = Portus::JwtToken.new(params[:account], params[:service], authorize_scopes)
    logger.tagged("jwt_token", "claim") { logger.debug token.claim }
    render json: token.encoded_hash
  end

  private

  # If there was a scope specified in the request parameters, try to authorize
  # the given scopes. That is, it "filters" the scopes that can be requested
  # depending of the issuer of the request and its permissions.
  #
  # If no scope was specified, this is a login request and it just returns nil.
  def authorize_scopes
    scopes =  Array(Rack::Utils.parse_query(request.query_string)["scope"])
    return if scopes.empty?

    auth_scopes = {}

    # First try to fetch the requested scopes and the handler. If no scopes
    # were successfully given, respond with a 401.
    scopes.each do |scope|
      auth_scope, actions = scope_handler(scope)

      actions.each do |action|
        # It will try to check if the current user is authorized to access the
        # scope given in this iteration. If everything is fine, then nothing will
        # happen, otherwise there are two possible exceptions that can be raised:
        #
        #   - NoMethodError: the targeted resource does not handle the scope that
        #     is being checked. It will raise a ScopeNotHandled.
        #   - Pundit::NotAuthorizedError: the targeted resource unauthorized the
        #     given user for the scope that is being checked. In this case this
        #     scope gets removed from `auth_scope.actions`.
        begin
          authorize auth_scope.resource, "#{action}?".to_sym
        rescue NoMethodError, Pundit::NotAuthorizedError, Portus::AuthScope::ResourceNotFound
          logger.debug "action #{action} not handled/authorized, removing from actions"
          auth_scope.actions.delete_if { |a| match_action(action, a) }
        end
      end

      next if auth_scope.actions.empty?
      # if there is already a similar scope (type and resource name),
      # we combine them into one:
      # e.g. scope=repository:busybox:push&scope=repository:busybox:pull
      #      -> access=>[{:type=>"repository", :name=>"busybox", :actions=>["push", "pull"]}
      k = [auth_scope.resource_type, auth_scope.resource_name]
      if auth_scopes[k]
        auth_scopes[k].actions.concat(auth_scope.actions).uniq!
      else
        auth_scopes[k] = auth_scope
      end
    end
    auth_scopes.values
  end

  # Returns true if the given item matches the given action.
  def match_action(action, item)
    action = "*" if action == "all"
    action == item
  end

  # From the given scope string, try to fetch a scope handler class for it.
  # Scope handlers are defined in "app/models/*/auth_scope.rb" files.
  def scope_handler(scope_string)
    str = scope_string.split(":", 3)
    raise ScopeNotHandled, "Wrong format for scope string" if str.length != 3

    case str[0]
    when "repository"
      auth_scope = Namespace::AuthScope.new(scope_string)
    when "registry"
      auth_scope = Registry::AuthScope.new(scope_string)
    else
      raise ScopeNotHandled, "Scope not handled: #{str[0]}"
    end

    [auth_scope, auth_scope.scopes.dup]
  end

end

