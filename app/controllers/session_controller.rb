class SessionController < ApplicationController
  layout "session"

  skip_before_action :login_required, except: :destroy
  before_action :required_not_login, except: [:destroy, :particles]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if !User.exists?(email: @user.email)
      flash.alert = t("alert.account_not_exist")
      render :new and return
    end

    @login_user = User.find_by(email: @user.email)

    if @login_user.password_valid?(@user.password)
      audit(current_user, "login")
      session[:user_id] = @login_user.id
      redirect_to root_path, notice: t("notice.login_success")
    else
      flash.alert = t("alert.password_invalid")
      render :new
    end
  end

  def destroy
    audit(current_user, "logout")
    session[:user_id] = nil
    redirect_to new_session_path
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
