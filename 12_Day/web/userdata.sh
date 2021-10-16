#!/bin/bash
sudo apt-get update
sudo apt-get -y install nginx
sudo touch /var/www/html/index.html
sudo chown ubuntu /var/www/html/index.html
sudo cat > /var/www/html/index.html <<EOF
<h1>Sri Swami Samarth</h1>
<h2>DB String : ${dbstring}</h2>
EOF