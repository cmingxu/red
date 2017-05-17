class RegistryController < ApplicationController
  skip_before_action :login_required, :set_page_request_meta_info, :set_locale
  skip_before_action :verify_authenticity_token


  def notifications
    ap JSON.parse(request.raw_post)
    ap params[:events]
    head :ok
  end
end
