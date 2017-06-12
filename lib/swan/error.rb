# This module holds the Errors for the gem.
module Swan::Error
  # The default error. It's never actually raised, but can be used to catch all
  # gem-specific errors that are thrown as they all subclass from this.
  class SwanError < StandardError; attr_accessor :details end

  # Raised when invalid arguments are passed to a method.
  class ArgumentError < SwanError;
  end

  # Raised when a request returns a 400 or 422.
  class ClientError < SwanError;
  end

  # Raised when a request returns a 404.
  class NotFoundError < SwanError;
  end

  # Raised when there is an unexpected response code / body.
  class UnexpectedResponseError < SwanError;
  end

  # Raised when a request times out.
  class TimeoutError < SwanError;
  end

  # Raised when login fails.
  class AuthenticationError < SwanError;
  end

  # Raised when an IO action fails.
  class IOError < SwanError;
  end

  # Raise error specific to http response.
  # ++response++: HTTParty response object.
  def from_response(response)
    err = error_class(response).new(error_message(response))
    err.details = error_details(response)
    err
  end

  private

  # Get reponse code specific error class.
  # ++response++: HTTParty response object.
  def error_class(response)
    case response.code
    when 400
      ClientError
    when 422
      ClientError
    when 404
      NotFoundError
    else
      UnexpectedResponseError
    end
  end

  # Get response code from http response.
  # ++response++: HTTParty response object.
  def error_message(response)
    body = response.parsed_response
    if not body.is_a?(Hash)
      body
    elsif body['message']
      body['message']
    elsif body['errors']
      body['errors']
    else
      body
    end
  end

    # Get response code from http response.
    # ++response++: HTTParty response object.
    def error_details(response)
      body = response.parsed_response
      if not body.is_a?(Hash)
        body
      elsif body['details']
        body['details']
      elsif body['errors']
        body['errors']
      else
        body
      end
    end

  module_function :error_class, :error_message, :from_response, :error_details

end

