#!/bin/bash

#create minecraft user
wall testing

#get all needed dependencies (docker)
sudo yum update -y
sudo yum install -y docker
sudo adduser minecraft

sudo service docker start
sudo usermod -aG docker minecraft

#restart the ssh instance so that new permissions are applied
exit
