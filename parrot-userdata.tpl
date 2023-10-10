#!/bin/bash
sudo hostnamectl set-hostname ${new_hostname}
sudo yum -y update
sudo yum -y install docker
sudo usermod -aG docker ec2-user &&
sudo systemctl enable docker
sudo systemctl start docker
sudo docker pull parrotsec/security
touch ~/start-parrot.sh
chmod 0700 ~/start-parrot.sh
echo "sudo docker run --rm -ti --network host -v $PWD/work:/work parrotsec/security" > ~/start-parrot.sh
sudo reboot
