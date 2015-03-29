class ReservationsController < ApplicationController
  def index
    # return user's list of reservations
    @reservations = []
  end

  def new

    container = Docker::Container.create(Cmd: '/bin/sh', Image: 'fedora')
    puts container.json
    container.start
    puts container.json
    # Short lived...next step is to figure out how to make long running
    # and ability to ssh in/out at will.

    # if reservation created successfully
    if false
      flash[:success] = "Reservation created successfully"
    else
      flash[:error] = "Failed to create reservation"
    end
    redirect_to reservations_path
  end

  def destroy
    # if reservation deleted successfully
    if false
      flash[:success] = "Reservation deleted"
    else
      flash[:error] = "Failed to delete reservation"
    end
    redirect_to reservations_path
  end
end
