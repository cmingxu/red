class RbacController < ApplicationController
  def index
    @groups = current_user.groups.includes(:users).order(created_at: :desc).page params[:page]
    @group = current_user.groups.find_by(id: params[:group_id]) || @groups.first
  end
end
