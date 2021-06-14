#!/bin/bash


source components/common.sh


OS_PREREQ

Head "Adding user"
useradd -m -s /bin/bash app &>>$LOG

Head "Changing directory"
cd /home/app/


rm -rf users
DOWNLOAD_COMPONENT
Stat $?


apt update
Stat $?

Head "Installing Java"
apt install openjdk-8-jdk-headless -y &>>$LOG
Stat $?

Head "Exporting java-jdk to JAVA_HOME"
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
Stat $?

Head "Installing Maven"
apt install maven -y &>>$LOG
Stat $?

cd /home/todo/users/

Head "Maven Packages"
mvn clean package &>>$LOG

Head "pass the EndPoints in Service File"
sed -i -e "s/REDIS_ENDPOINT/users.${DOMAIN}/" systemd.service
Stat $?

Head "Setup the systemd Service"
mv systemd.service /etc/systemd/system/uesrs.service &>>$LOG
Stat $?
systemctl daemon-reload && systemctl start users && systemctl enable users &>>$LOG
Stat $?