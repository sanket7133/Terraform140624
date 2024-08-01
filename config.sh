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

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

sudo aws configure set default.region "ap-south-1"
sudo aws configure set default.output json

sudo aws configure set aws_access_key_id ${AWS_Access_ID}
sudo aws configure set aws_secret_access_key ${AWS_secrete_key}

sudo apt-get update