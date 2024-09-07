#! /bin/bash

apt update
apt upgrade -y
apt install nginx -y
apt install wget -y
cd /var/www
wget https://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
rm -rf latest.tar.gz
sudo chown -R www-data:www-data wordpress
sudo find wordpress/ -type d -exec chmod 755 {} \;
sudo find wordpress/ -type f -exec chmod 644 {} \;

