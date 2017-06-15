class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :leave]
  before_action :set_group, only: [:leave, :create]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  %w(cpu mem disk).each do |m|
    define_method "update_quota_#{m}" do
      @user = User.find params[:id]
      @user.settings(:quota).send("#{m}=", params[:value])
      if @user.save
        audit(@user, "update", @user.name + " update #{m} to #{params[:value]}" )
        flash.notice = t("common.user_quota_update_success")
      else
        flash.alert = t("common.user_quota_update_fail")
      end

      redirect_to groups_path
    end
  end


  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.update_password @user.password

    if !@user.icon.present?
      random_icon = Dir.glob(Rails.root.join("app/assets/images/user-profile-icon/*")).shuffle.first
      @user.icon = Pathname.new(random_icon).open
    end

    respond_to do |format|
      if @user.save
        @group.add_user!(@user, @user.group_admin_accessor == "true" ? :admin : :user)
        Group.default_group.add_user!(@user, @user.site_admin_accessor == "true" ? :site_admin : :user)

        audit(@user, "create", @user.name)

        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
        format.js { render :js => 'window.location.reload();' }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js { render }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        audit(@user, "update", @user.name)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def leave
    #TODO permission check

    audit(@user, "destroy", @user.name + " " + @group.name)
    @user.leave_group! @group
    redirect_to group_path(@group)
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    # TODO permission check
    respond_to do |format|
      can_remove_user = !(@user.site_admin? && (Group.default_group.site_admins.length == 1))
      if  can_remove_user || @user.destroy
        audit(@user, "destroy", @user.name)
        format.html { redirect_to groups_path, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to groups_path, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :password, :group_admin_accessor, :site_admin_accessor)
  end
end
