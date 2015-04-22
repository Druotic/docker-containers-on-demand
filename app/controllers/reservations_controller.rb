class ReservationsController < ApplicationController
  def index
    # return user's list of reservations
    @reservations = current_user.reservations
  end

  def create

    # Generate 16 byte hex container name. Low probability of name
    # collision, but a future enhancement would be to check for uniqueness
    # before attempting to launch container
    container_name = SecureRandom.hex(16)

    # Use first part of email as username
    username = current_user.email.split("@").first

    # Generate random 6 (3 byte) hex digit password (temporary)
    password = SecureRandom.hex(3)

    # temporary solution - this assumes the web server is running on the same
    # machine as the docker node.  Future enhancement would be to obtain public hostname/ip
    # of docker node from elsewhere
    host = request.host
    port = launch container_name, username, password

    if port > -1 && current_user.reservations.create(container_name: container_name,
          host: host, port: port, userid: username, default_pass: password, created_at: Time.now)
      flash[:success] = "Reservation created successfully"
      logger.info "Container #{container_name} launched successfully!"
    else
      flash[:error] = "Failed to create reservation"
      logger.error "Container #{container_name} failed to launch."
    end
    redirect_to reservations_path
  end

  def destroy
    res = current_user.reservations.find(params[:id])

    # Future enhancement - check if docker container was deleted successfully
    terminate res.container_name

    if res.destroy
      flash[:success] = "Reservation deleted"
      logger.info "Container #{res.container_name} successfully deleted."
    else
      flash[:error] = "Failed to delete reservation"
      logger.error "Failed to stop or delete container #{res.container_name}."
    end
    redirect_to reservations_path
  end

  private

  def launch(container_name, user, pass)
    logger.info "Attempting launch with params: #{container_name} #{user} #{pass}"
    result = `lib/scripts/launch.sh #{container_name} #{user} #{pass} | tail -n 1`
    result.chomp!

    results = result.split
    port = results[0]
    launch_status = results[1]
    pwd_change_status = results[2]

    if launch_status != "0"
      logger.error "Launch (#{container_name}) failed with status #{launch_status}!"
    end
    if pwd_change_status != "0"
      logger.error "Password change (#{container_name}) failed with status #{pwd_change_status}!"
    end

    return (launch_status == "0" && pwd_change_status == "0") ? port.to_i : -1
  end

  def terminate(container_name)
    cont = Docker::Container.get(container_name)
    cont.stop
    cont.delete(force: true)
    logger.info "Deleted docker container #{container_name}"
  end
end
