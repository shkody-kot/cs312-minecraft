#!/bin/bash

# pull docker container
docker pull itzg/minecraft-server

#create service to start the container on start
cd /etc/systemd/system/
sudo touch minecraft.service
sudo printf '[Unit]\ndescription=Minecraft Server on start-up\nWants=network-online.target\n[Service]\nUser=minecraft\nExecStart=docker run -d -p 25565:25565 --name mc itzg/minecraft-server\nStandardInput=null\n[Install]\nWantedBy=multi-user.target' >> minecraft.service

#create service to terminate container on stop
sudo touch minecraft-stop.service
sudo printf '[Unit]\nDescription=Stop server on shutdown\nBefore=halt.target shutdown.target reboot.target\n[Service]\nType=oneshot\nUser=minecraft\nExecStart=docker stop mc\n[Install]\nWantedBy=halt.target shutdown.target reboot.target' >> minecraft-stop.service

#start and enable the services
sudo systemctl daemon-reload
sudo systemctl enable minecraft-stop.service
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service

#test
sudo systemctl status minecraft
sudo systemctl status minecraft-stop
