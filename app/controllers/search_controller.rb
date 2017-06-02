class SearchController < ApplicationController
  skip_before_action :login_required

  def owner_search
    @users = User.where("email like ? OR name like ?", "%#{params[:search]}%", "%#{params[:search]}%")
    @groups = Group.where("name like ?", "%#{params[:search]}%")

    respond_to do |format|
      format.html {}
      format.json {}
    end
  end

  def list_owner
    @users = User.all
    @groups = Group.all

    respond_to do |format|
      format.html {}
      format.json { render :owner_search }
    end
  end
end
