class GroupApplicationsController < ApplicationController

  def index
  end

  def create
    ga = GroupApplication.new(group_application_params)
    ga.save
    flash[:success] = "Application submitted"
    redirect_to Group.find(ga.group_id)
  end

  private

  def group_application_params
    params.require(:group_application).permit(:user_id, :group_id)
  end
end
