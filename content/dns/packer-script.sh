#!/bin/bash
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y unbound unbound-anchor dns-root-data
sudo mkdir -p /etc/unbound/dev /etc/unbound/var/lib/unbound
sudo touch /etc/unbound/dev/urandom /etc/unbound/dev/log /etc/unbound/unbound.log /etc/unbound/unbound.pid
sudo chown unbound:unbound /etc/unbound/unbound.log /etc/unbound/unbound.pid
sudo chown -R unbound:unbound /etc/unbound
sudo ln -s /etc/unbound/unbound.log /var/log/unbound.log
sudo cp /var/lib/unbound/root.key /etc/unbound/var/lib/unbound/
sudo cp /usr/share/dns/root.hints /etc/unbound/unbound.conf.d/named.root
cat /tmp/fstab | sudo tee -a /etc/fstab
sudo cp /tmp/usr.sbin.unbound /etc/apparmor.d/usr.sbin.unbound
sudo mount -a
sudo mv /etc/unbound/unbound.conf.d/root-auto-trust-anchor-file.conf /root/
#sudo systemctl disable systemd-resolved.service
#sudo systemctl stop systemd-resolved.service
#sudo systemctl enable unbound.service
sudo service apparmor restart
#sudo service unbound restart
#echo nameserver 127.0.0.1 | sudo tee /etc/resolv.conf
#echo search {{SITE}}.test | sudo tee -a /etc/resolv.conf
echo $(ip -4 address show dev $(ip -4 route show default | grep -o dev.* | awk '{print $2;}') | grep inet | awk '{print $2}' | grep -Eo -m 1 '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}') $(hostname) | sudo tee -a /etc/hosts
