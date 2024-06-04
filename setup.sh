#!/bin/bash

#create minecraft user
wall testing

#get all needed dependencies (docker)
sudo yum update -y
sudo yum install -y docker
sudo yum install -y java-22-amazon-corretto-headless

sudo adduser minecraft

sudo service docker start
sudo usermod -aG docker minecraft ec2-user

#restart the ssh instance so that new permissions are applied
exit
