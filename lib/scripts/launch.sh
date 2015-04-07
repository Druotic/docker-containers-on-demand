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
# $2 => username for new owner of container
# $3 => password for new owner

# Directory containing launch.sh and change_passwd.exp
CURRENT_DIR="`pwd`/`dirname $0`"

# Launch new container
docker run -d --name ${1} -P sktomer/centos7_ssh_plus_user_acc
launch_status=`echo $?`
port=`docker inspect ${1} | grep HostPort | egrep -o [0-9]+`

sleep 5

# Get auto-generated root and app-admin passwords from container logs
# rootpass=`docker logs ${1} | grep "root :" | awk 'NF>1{print $NF}'`;
# adminpass=`docker logs ${1} | grep "app-admin :" | awk 'NF>1{print $NF}'`;
# container created with default password `csc547team4`
password=csc547team4

# SSH into container, create user account and change password
expect -f $CURRENT_DIR/change_passwd.exp $port $password $2 $3
pwd_change_status=`echo $?`


echo "$port $launch_status $pwd_change_status"
