class ReservationsController < ApplicationController
  def index
    # return user's list of reservations
    @reservations = current_user.reservations
  end

  def new

    # Generate 16 byte hex container name. Low probability of name
    # collision, but a future enhancement would be to check for uniqueness
    # before attempting to launch container
    container_name = SecureRandom.hex(16)

    # Use first part of email as username
    username = current_user.email.split("@").first

    # Generate random 6 (3 byte) hex digit password (temporary)
    password = SecureRandom.hex(3)

    params = "#{container_name} #{username} #{password}"

    status = `lib/scripts/launch.sh #{container_name} #{username} #{password} &> /dev/null; echo $?`
    status.chomp!

    if status == "0" && current_user.reservations.create(container_name: container_name, userid: username, default_pass: password, created_at: Time.now)
      flash[:success] = "Reservation created successfully"
      puts "Success! Params: #{params}"
    else
      flash[:error] = "Failed to create reservation"
      puts "Failed! Params: #{params}"
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
