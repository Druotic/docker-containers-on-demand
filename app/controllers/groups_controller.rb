class GroupsController < ApplicationController
  def new
  end

  def create
    # Store member_id, delete member_id attribute, and save.
    params[:group][:user_ids] = [group_params[:member_id]]
    params[:group].delete(:member_id)
    @group = Group.new(group_params)
    @group.save
    redirect_to @group
  end

  def show
    @group = Group.find(params[:id])
  end

  def index
    @groups = Group.all
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
    params.require(:group).permit(:leader_id, :member_id, :course, :participantNumber, :frequency, :place,
                                  :time, :dayOfWeek, :date, :user_ids => [])
  end
end
