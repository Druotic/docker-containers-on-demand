class GroupsController < ApplicationController
	def new
  end

  def create
    @group = Group.new(params[:group])

    @group.save
    redirect_to @group
  end

  def show
    @group = Group.find(params[:id])
  end

  def index
    @groups = Group.all
  end
end
