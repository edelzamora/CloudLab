#!/bin/bash
sudo hostnamectl set-hostname ${new_hostname} &&
sudo yum -y update &&
sudo yum -y install httpd &&
sudo systemctl start httpd &&
sudo systemctl enable httpd
