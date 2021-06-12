#!/bin/bash

source components/common.sh

#Used export instead of service file
DOMAIN=ksrihari.online

OS_PREREQ

Head "Installing Nginx"
apt install nginx -y &>>$LOG
Stat $?

Head "Installing npm and nodejs"
cd
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - &>>$LOG
sudo apt-get install nodejs -y &>>$LOG
apt install npm -y &>>$LOG
Stat $?

Head "Create directory"
cd /var/www/html/
mkdir todo  &>>$LOG
cd todo
Stat $?

Head "Downloading Component"
DOWNLOAD_COMPONENT
Stat $?

cd frontend

Head "Installing npm"
npm install &>>$LOG
Stat $?

Head "run and build npm"
npm install node-sass &>>$LOG
npm run build &>>$LOG
sudo npm install --save-dev  --unsafe-perm node-sass &>>$LOG
Stat $?

Head "Update Nginx Configuration"
  sed -i 's+/var/www/html+/var/www/html/todo/frontend/dist+g' /etc/nginx/sites-available/default
Stat $?

Head "------------------------------"
sed -i '32 s/127.0.0.1/login.$DOMAIN/g' /var/www/html/todo/frontend/config/index.js
sed -i '36 s/127.0.0.1/todo.$DOMAIN/g' /var/www/html/todo/frontend/config/index.js
#sed -i '40 s/127.0.0.1/0.0.0.0/g' /var/www/html/todo/frontend/config/index.js
Stat $?

Head "Starting NPM"
systemctl restart nginx
npm start
Stat $?