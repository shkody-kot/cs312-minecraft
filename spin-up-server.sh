#!/bin/bash
echo Creating EC2 instance
pwd
#provision infrastructure
terraform apply
terraform show | grep public_ip

#get public IP

#log in to EC2 instance
ssh -i "minecraft-automation.pem" ec2-user@ec2-35-165-57-20.us-west-2.compute.amazonaws.com

