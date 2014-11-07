class GroupsController < ApplicationController
  def new
  end

  def create
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
    params.require(:group).permit(:leader, :course, :participantNumber, :frequency, :place,
                                  :time, :dayOfWeek, :date)
  end
end
