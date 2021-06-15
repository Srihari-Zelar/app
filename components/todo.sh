#!/bin/bash

source components/common.sh

#Used export instead of service file
DOMAIN=ksrihari.online

OS_PREREQ

Head "Installing npm"
apt install npm -y &>>$LOG
Stat $?

Head "Adding user"
useradd -m -s /bin/bash app &>>$LOG
Stat $?

Head "Changing directory"
cd /home/app/
Stat $?

Head "Downloading Component"
DOWNLOAD_COMPONENT
Stat $?

cd todo/

Head "Installing NPM"
npm install -y &>>$LOG
Stat $?

Head "pass the EndPoints in Service File"
sed -i -e "s/REDIS_ENDPOINT/172.31.82.102/" systemd.service
Stat $?

Head "Setup the systemd Service"
mv systemd.service /etc/systemd/system/todo.service &>>$LOG
Stat $?
systemctl daemon-reload && systemctl start todo && systemctl enable todo &>>$LOG
Stat $?