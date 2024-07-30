#!/bin/bash
apt update
sudo apt install fontconfig openjdk-17-jre -y

java --version 

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y


systemctl enable jenkins
systemctl start jenkins

sudo apt-get update
sudo apt-get install docker.io -y

sudo usermod -aG docker ubuntu  

newgrp docker

sudo chmod 777 /var/run/docker.sock


systemctl enable docker
systemctl start docker

