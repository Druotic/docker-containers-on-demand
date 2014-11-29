class GroupsController < ApplicationController
  def new
  end

  def create
    # Store member_id, delete member_id attribute, and save.
    params[:group][:user_ids] = [group_params[:member_id]]
    params[:group].delete(:member_id)
    @group = Group.new(group_params)
    if @group.save
      flash[:success] = "Group successfully created"
      redirect_to @group
    else
      flash.now[:danger] = "Failed to create group, check required fields"
      render new_group_path
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  def index
    if params[:scope] == "my groups"
      @groups = current_user.groups
    elsif params[:scope] == "pending"
      @groups = Group.all.select do |group| current_user.is_pending_applicant? group end
    elsif params[:scope] == "new"
      @groups = Group.all - current_user.groups - Group.all.select do |group| current_user.is_pending_applicant? group end
    else
      @groups = Group.all
    end
  end

  def destroy
    group = Group.find(params[:id])
    if group.destroy
      flash[:success] = "Group successfully deleted"
    else
      flash[:danger] = "Group could not be deleted"
    end

    redirect_to groups_path
  end

  def edit
    @group = Group.find(params[:id])
  end
  def update
    if params[:user_id].blank?
      group = Group.find(params[:id])
      if group.update_attributes(group_params)
        flash[:success] = "Sucessfully updated group"
      else
        flash[:failure] = "Failed to update group"
      end
      redirect_to group
      return
    end

    group = Group.find(params[:id])
    group.users.delete(User.find(params[:user_id]))
    if group.save
      flash[:success] = "Successfully removed from group"
    else
      flash[:failure] = "Removal from group failed"
    end

    redirect_to :back
  end

  private

  # This is used for ActiveModel 4.0's strong parameter enforcement - it didn't
  # give any errors previously because MongoMapper was using an older version of
  # ActiveModel
  # ref - http://edgeapi.rubyonrails.org/classes/ActionController/StrongParameters.html
  def group_params
    # note: member_id is not saved to the database, it should be added to user_ids and then deleted from the hash.
    # In other words, we need a way to pass the member_id from the view (which may or may not be the same as leader_id),
    # but we don't want to pass the hash with member_id in it to the  #new call.  Having to always delete it seems
    # bad.  TODO: Better way to do this?
    params.require(:group).permit(:leader_id, :member_id, :title, :course, :participantNumber, :frequency, :place,
                                  :time, :date, :description, :user_ids => [])
  end
end
