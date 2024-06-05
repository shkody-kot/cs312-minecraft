#!/bin/bash
echo Creating EC2 instance
pwd
#provision infrastructure
terraform apply

#get public IP
output=$(terraform show | grep "public_ip" | sed '2p;d')
ip=`echo "$output" | cut -d '"' -f 2`
echo Public IP: $ip

#Log into EC2 instance
ssh -i "minecraft-automation.pem" ec2-user@$ip 'bash -s' < setup.sh

ssh -i "minecraft-automation.pem" ec2-user@$ip 'bash -s' < server.sh

echo Public IP: $ip
