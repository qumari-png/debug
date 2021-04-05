#!/bin/sh

apt-get upgrade 
apt-get install -y unattended-upgrades
apt-get install -y nginx
apt-get install -y curl
apt-get install -y secure-delete
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt-get install -y nodejs
npm install pm2 -g
npm install request
npm install shelljs

# CHECKER
pm2 start checker.js
pm2 startup
pm2 save

# SSL
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

# NGINX
mv default /etc/nginx/sites-available/default
mv ssl-params.conf /etc/nginx/snippets/ssl-params.conf
mv self-signed.conf /etc/nginx/snippets/self-signed.conf
mv cloudflare-allow.conf /etc/nginx/cloudflare-allow.conf
mv proxy-params.conf /etc/nginx/conf.d/proxy-params.conf

service nginx restart
echo "DONE"
