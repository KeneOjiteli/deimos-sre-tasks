#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;

events {
    worker_connections  1024;
}

http {

    proxy_connect_timeout 180s;
    proxy_send_timeout 180s;
    proxy_read_timeout 180s;

    include /etc/nginx/mime.types;

    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;

    # Adds the IP and port of the 2 VMs
    upstream myloadbalancer {
       # least_conn;
        server 192.168.216.167:80;
        server 192.168.216.202:80;
    }

 
    server {
        listen       80;
        server_name  192.168.216.140;

        location / {
	    try_files $uri $uri/ /index.html;
            proxy_pass   http://myloadbalancer;
            include /etc/nginx/mime.types;
            #proxy_set_header Host $host;
        }
    }
}

