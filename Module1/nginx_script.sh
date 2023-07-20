#!/bin/bash

# This script will install nginx server from source


#Update the system  and  install the required dependencies
#Such as zlib1g for gzip compression and build-essential for gcc and make

sudo apt update && sudo apt install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libgd-dev libxml2 libxml2-dev uuid-dev

#using wget, download  nginx source code with preferred version (latest version)
wget http://nginx.org/download/nginx-1.24.0.tar.gz

#Extract nginx
tar -zxvf nginx-1.24.0.tar.gz

#List files and  go to nginx directory
ls
cd nginx-1.24.0

#Configure nginx and pass necessary modules, with logs and configuration file
./configure \
    --prefix=/etc/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/run/nginx.pid \
    --sbin-path=/usr/sbin/nginx \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_stub_status_module \
    --with-http_realip_module \
    --with-file-aio \
    --with-threads \
    --with-stream \
    --with-stream_ssl_preread_module

#Run make command to build and install nginx 
make && sudo  make install


#Verify nginx is installed by checking for version
nginx -V

#Create systemd file path and save in a variable, create a service on this path
systemd_file ="/lib/systemd/system/nginx.service"


sudo tee ${systemd_file} > /dev/null <<EOT
[Unit]
Description=Nginx Custom From Source
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOT

#Create a directory
sudo mkdir /var/www/html
sudo mkdir /etc/nginx/sites-enabled
sudo mkdir /etc/nginx/sites-available

#Move directory  with application to /var/www/html directory
sudo mv vm1-app/web-app /var/www/html
cd /var/www/html/web-app
start index.html


cd sites-available

CONFIG_FILE="/etc/nginx/sites-available/default"

#Edit the default configuration file
cat << EOF | sudo tee "$CONFIG_FILE" > /dev/null
server {
    listen 80  default_server;
#	listen [::]:80 default_server;
    root /var/www/html/web-app;
    index index.html index.htm;
    server_name _;
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Create a symbolic link to enable the configuration
sudo ln -s "$CONFIG_FILE" /etc/nginx/sites-enabled/default

# Backing up the original nginx.conf file to nginx.conf.bak file
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# Verify the Nginx configuration
sudo nginx -t

#Reload systemd and enable nginx service to auto-start after server boots
sudo systemctl daemon-reload
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx

# Restart Nginx 
sudo systemctl restart nginx

#create a group for nginx users
sudo groupadd nginx_grp 

#Create a user and add to group created above
sudo useradd -r -g nginx_grp  nginx_user

#Cron job to back up nginx folder

# Create folder for backup and create location
#sudo mkdir bckup_nginx

#bckup_location="/home/kene/bckup_nginx"

# Create the backup directory
#mkdir -p "$bckup_location"
 

# Add the cron job to perform the backup
#(crontab -l 2>/dev/null; echo "0 0 * * * cp -R /var/www/html $bckup_location && cp -R /etc/nginx $bckup_location && cp -R /var/log $bckup_location") | crontab -

#echo "Nginx backup is set up."
