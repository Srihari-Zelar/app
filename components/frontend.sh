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
Stat $?

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


cd frontend

Head "run and build npm"

npm install -g npm@latest &>>$LOG
npm install shelljs &>>$LOG
npm install --save-dev  --unsafe-perm node-sass &>>$LOG
npm run build  &>>$LOG
Stat $?

Head "replasing domains"

sed -i '32 s/127.0.0.1/login.ksrihari.online/g' /var/www/html/app/frontend/config/index.js
sed -i '36 s/127.0.0.1/todo.ksrihari.online/g' /var/www/html/app/frontend/config/index.js
Stat $?

Head "Starting NPM"
npm start
Stat $?
