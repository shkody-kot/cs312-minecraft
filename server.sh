#!/bin/bash

# pull docker container
sudo su
#docker pull itzg/minecraft-server

#try manual mode
mkdir -p /opt/minecraft/server
cd /opt/minecraft/server
wget https://piston-data.mojang.com/v1/objects/145ff0858209bcfc164859ba735d4199aafa1eea/server.jar
java -Xmx1024M -Xms1024M -jar server.jar nogui
sleep 60

sed -i 's/false/true/p' eula.txt

touch start
touch stop
printf '#!/bin/bash\njava -Xmx1024M -Xms1024M -jar server.jar nogui' > start
printf '#!/bin/bash\nkill -9 $(ps -ef |pgrep -f "java")' > stop

chmod +x start stop

chown -R minecraft:minecraft /opt/minecraft/


#create service to start the container on start
cd /etc/systemd/system/
touch minecraft.service
#printf '[Unit]\nDescription=Minecraft Server on start-up\nAfter=docker.service\nRequires=docker.service\nWants=network-online.target\n[Service]\nTimeoutStartSec=0\nRestart=always\nExecStartPre=-/usr/bin/docker stop mc\nExecStartPre=-/usr/bin/docker rm mc\nExecStart=/usr/bin/docker run -d -p 25565:25565 --name mc itzg/minecraft-server\nStandardInput=null\n[Install]\nWantedBy=multi-user.target' > minecraft.service
printf '[Unit]\nDescription=Minecraft Server on start-up\nWants=network-online.target\n[Service]\nUser=minecraft\nWorkingDirectory=/opt/minecraft/server\nExecStart=/opt/minecraft/server/start\nStandardInput=null\n[Install]\nWantedBy=multi-user.target' > minecraft.service


#create service to terminate container on stop
touch minecraft-stop.service
#printf '[Unit]\nDescription=Stop server on shutdown\nBefore=halt.target shutdown.target reboot.target\n[Service]\nType=oneshot\nExecStart=/usr/bin/docker stop mc\n[Install]\nWantedBy=halt.target shutdown.target reboot.target' > minecraft-stop.service
printf '[Unit]\nDescription=Stop server\nBefore=shutdown.target\n[Service]\nUser=minecraft\nWorkingDirectory=/opt/minecraft/server\nExecStart=/opt/minecraft/server/stop\nStandardInput=null\n[Install]\nWantedBy=multi-user.target' >minecraft-stop.service

#start and enable the services
systemctl daemon-reload
systemctl enable minecraft-stop.service
systemctl enable minecraft.service
systemctl start minecraft.service

#test
systemctl status minecraft
systemctl status minecraft-stop
