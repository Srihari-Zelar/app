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
apt install openjdk-8-jre-headless -y &>>$LOG
apt install openjdk-8-jdk-headless -y &>>$LOG
Stat $?

Head "Exporting java-jdk to JAVA_HOME"
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
Stat $?

Head "Installing Maven"
apt install maven -y &>>$LOG
Stat $?

cd /home/app/users/

Head "Maven Packages"
mvn clean package &>>$LOG
Stat $?

Head "pass the EndPoints in Service File"
sed -i -e "s/REDIS_ENDPOINT/172.31.82.102/" systemd.service
Stat $?

Head "Setup the systemd Service"
mv systemd.service /etc/systemd/system/users.service &>>$LOG
Stat $?

systemctl daemon-reload && systemctl start users && systemctl enable users &>>$LOG
Stat $?