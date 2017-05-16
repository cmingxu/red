class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :set_groups

  # GET /groups
  # GET /groups.json
  def index
    @group = current_user.groups.find_by(id: params[:group_id]) || @groups.first
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = current_user.groups.includes(:group_users).find params[:id]
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @group.owner = current_user

    respond_to do |format|
      if @group.save && @group.add_user!(current_user, :admin)
        audit(@group, "create", @group.name)
        format.html { redirect_to :back, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        audit(@group, "update", @group.name)
        format.html { redirect_to group_path(@group), notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  %w(cpu mem disk).each do |m|
    define_method "update_quota_#{m}" do
      @group = Group.find params[:id]
      @group.settings(:quota).send("#{m}=", params[:value])
      if @group.save
        audit(@group, "update", @group.name + " update #{m} to #{params[:value]}" )
        flash.notice = t("common.user_quota_update_success")
      else
        flash.alert = t("common.user_quota_update_fail")
      end

      redirect_to groups_path
    end
  end


  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    audit(@group, "destroy", @group.name )
    respond_to do |format|
      format.html { redirect_to groups_path, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  def set_groups
    @groups = current_user.groups.includes(:users).order(created_at: :asc).page params[:page]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:name, :desc, :icon)
  end
end
