#!/bin/bash
source components/common.sh
MAX_LENGTH=$( cat ${0} components/common.sh |grep STAT_CHECK |grep -v -W cat |awk -F '"' '{print$2}' |awk '{print length}' |sort |tail -1 )

echo "Catalogue Setup"

# curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
STAT_CHECK $? "Install nodejs"

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
useradd roboshop &>>${LOG_FILE}
STAT_CHECK $? "Add Application User"
fi

Download catalogue

mv /tmp/catalogue-main/* /home/roboshop/catalogue
STAT_CHECK $? "Move Catalogue Content"
cd /home/roboshop/catalogue && npm install --unsafe-perm &>>${LOG_FILE}
STAT_CHECK $? "Install NodeJs Dependencies"

chown roboshop:roboshop -R /home/roboshop

sed -i -e 's/MONGO_DNSNAME/mongo.roboshop.internal/' /home/roboshop/catalogue/systemd.service && mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
STAT_CHECK $? "Updated DNSNAME in SystemD"

echo "\e[1mService Enable And Start\e[0m"
systemctl daemon-reload &>>${LOG_FILE} && systemctl enable catalogue &>>${LOG_FILE} && systemctl start catalogue &>>${LOG_FILE}
STAT_CHECK $? "Service Enable And Start"
