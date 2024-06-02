#!/bin/bash
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nginx-light
sudo tar zxf $(find /tmp | grep webcontent) -C /var/www/html
