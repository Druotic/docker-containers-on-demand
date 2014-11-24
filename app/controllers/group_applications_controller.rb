class GroupApplicationsController < ApplicationController

  def index
    @group = Group.find(params[:group_id])
    @applications = GroupApplication.where(group_id: @group._id, status: :pending)
  end

  def create
    ga = GroupApplication.new(group_application_params)
    if ga.save
      flash[:success] = "Application submitted"
    else
      flash[:failure] = "Application submission failure"
    end
    redirect_to Group.find(ga.group_id)
  end

  def edit

  end

  def update
    ga = GroupApplication.find(params[:id])
    ga.status = params[:status]

    ga.group.users << ga.user if ga.status.to_sym == :accepted

    if ga.save
      flash[:success] = "Application #{params[:status]}"
    else
      flash[:failure] = "Application could not be updated"
    end
    redirect_to :back
  end

  private

  def group_application_params
    params.require(:group_application).permit(:user_id, :group_id)
  end
end
