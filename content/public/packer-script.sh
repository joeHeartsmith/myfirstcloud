#!/bin/bash
#sudo mkdir -p /tmp/.ssh
#sudo chmod 700 /tmp/.ssh
#sudo cp /tmp/site1-key_external.pub /tmp/.ssh/authorized_keys
#sudo chmod 600 /tmp/.ssh/authorized_keys
#sudo chown -R admin /tmp/.ssh
sudo sed -i 's/#Port 22/Port 20022/' /etc/ssh/sshd_config
sudo service ssh restart
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sudo sysctl -p
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
