#!/bin/bash

#install some dependencies
#Terraform
if [ $(dpkg-query -W -f='${Status}' terraform 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	echo Installing Terraform
	sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
	wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
	gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
	echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
	sudo apt update
	sudo apt-get -y install terraform
fi

#AWS CLI
if [ $(aws --version | grep -c "Command 'aws' not found") -eq 1 ];
then
	echo Installing AWS CLI
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
fi

#create key pair
ssh-keygen -t rsa -b 4096 -N "" -f minecraft-automation
mv test minecraft-automation.pem
chmod 400 minecraft-automation.pem

terraform init
