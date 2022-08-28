#!/bin/sh

source ./.env

apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release cifs-utils

mkdir -p $shared_dir

echo "username=$shared_dir_cifs_username \
password=$shared_dir_cifs_password" > $shared_dir_credentials
chmod 400 $shared_dir_credentials


echo "//$share_ip/$share_name $shared_dir cifs vers=3.0,credentials=$shared_dir_credentials" >> /etc/fstab



mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# su -c "useradd docker -s /bin/bash -m -g docker -G sudo"
# su -c "useradd docker -s /bin/bash -m -g docker -G sudo"

usermod -aG docker ubuntu # 2>&1 | tee usermod-docker.output
# echo "sudo usermod -aG docker $USER" 2>&1 | tee sudo-usermod-docker.output

echo "ubuntu:$ubuntu_password" | sudo chpasswd # 2>&1 | tee chpasswd.output
docker run hello-world 2>&1 | tee  hello-world.output

