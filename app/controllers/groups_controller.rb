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

  # This is used for Ruby 4.0's strong parameter enforcement - I'm surprised it didn't
  # give an error in the previous implementation (using mongo mapper)
  # ref - http://edgeapi.rubyonrails.org/classes/ActionController/StrongParameters.html
  def group_params
    params.require(:group).permit(:leader, :course)
  end
end
