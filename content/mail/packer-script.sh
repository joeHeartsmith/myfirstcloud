#!/bin/bash
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y dialog
sudo bash -c "wget --quiet https://github.com/iredmail/iRedMail/archive/refs/tags/1.6.8.tar.gz ; mv ./1.6.8.tar.gz /root/ ; cd /root ; tar zxf ./1.6.8.tar.gz ; cd iRedMail-1.6.8"
sudo cp /tmp/config /root/iRedMail-1.6.8/
