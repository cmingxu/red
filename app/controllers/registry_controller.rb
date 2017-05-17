class RegistryController < ApplicationController
  skip_before_action :login_required, :set_page_request_meta_info, :set_locale
  skip_before_action :verify_authenticity_token


  def notifications
    events_body = JSON.parse(request.raw_post)
    ap events_body

    Namespace.from_notifications(events_body['events']) if events_body['events'].present?
    head :ok
  end

end
