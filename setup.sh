#!/bin/bash

#create minecraft user
wall testing

#get all needed dependencies (docker, java)
sudo yum update -y > /dev/null
#sudo yum install -y docker > /dev/null
sudo yum install -y java-22-amazon-corretto-headless > /dev/null

sudo adduser minecraft > /dev/null

#sudo service docker start
#sudo usermod -aG docker minecraft ec2-user

#restart the ssh instance so that new permissions are applied
exit
