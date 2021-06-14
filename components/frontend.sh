#!/bin/bash

source components/common.sh

#Used export instead of service file
DOMAIN=ksrihari.online

OS_PREREQ

Head "Installing Nginx"
apt install nginx -y &>>$LOG
Stat $?

Head "starting Ngnix"
systemctl start nginx
systemctl enable nginx

Head "installing NPM"
apt install npm -y &>>$LOG
Stat $?

Head "Create directory"
cd /var/www/html/
mkdir app  &>>$LOG
cd app
Stat $?

rm -rf frontend
Stat $?

Head "Downloading Component"
DOWNLOAD_COMPONENT
Stat $?

cd frontend

Head "run and build npm"
sudo npm install --save-dev  --unsafe-perm node-sass &>>$LOG
Stat $?

Head "------------------------------"
sed -i '32 s/127.0.0.1/login.$DOMAIN/g' /var/www/html/app/frontend/config/index.js
sed -i '36 s/127.0.0.1/todo.$DOMAIN/g' /var/www/html/app/frontend/config/index.js
sed -i '40 s/127.0.0.1/0.0.0.0/g' /var/www/html/app/frontend/config/index.js
Stat $?

Head "Starting NPM"
systemctl restart nginx
npm start
Stat $?