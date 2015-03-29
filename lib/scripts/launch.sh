# This shell script will launch a container based on Cent-OS SSH container (jdeathe/centos-ssh:latest) and configure custom password on it
# Prior to this script run expect and docker must be installed on host
# sudo su
# yum install docker
# yum install expect
# You will also need to grant tty access for sudo, so create a new image ssh-tty-granted using "jdeathe/centos-ssh:latest" as base image
# Edit /etc/sudoers accordingly and commit
# All provisioning done in image launch-new

# Command line arguments : 
# $0 => ./launch.sh
# $1 => name of new container 
# $2 => port for new container
# $3 => username for new owner of container
# $4 => password for new owner

# Launch new container
docker run -d --name ${1} -p ${2}:22 sktomer/centos7_ssh_plus_user_acc
docker ps -a

sleep 5

# Get auto-generated root and app-admin passwords from container logs
# rootpass=`docker logs ${1} | grep "root :" | awk 'NF>1{print $NF}'`;
# adminpass=`docker logs ${1} | grep "app-admin :" | awk 'NF>1{print $NF}'`;
# launch_new creates container with default password `csc547team4`
password=csc547team4

# SSH into container, create user account and change password
expect -f change_passwd.exp $2 $3 $4

