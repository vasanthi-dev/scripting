#!/bin/bash

source components/common.sh
MAX_LENGTH=$( cat $0 |grep STAT_CHECK |grep -v cat |awk -F '"' '{print$2}' |awk '{print length}' |sort |tail -1 )
echo "\e[1mMongodb Installation\e[0m"

echo "\e[1mDownloading Mongodb Repo\e[0m"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>{LOG_FILE}
STAT_CHECK $? "Downloading Mongodb Repo"

echo "\e[1mInstalling Mongodb\e[0m"
yum install mongodb-org -y &>>{LOG_FILE}
STAT_CHECK $? "Installing Mongodb"

echo "\e[1mUpdate Mongodb Service\e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>{LOG_FILE}
STAT_CHECK $? "Update Mongodb Service"

echo "\e[1mService Enable And Start\e[0m"
systemctl enable mongod &>LOG_FILE && systemctl start mongod &>>{LOG_FILE}
STAT_CHECK $? "Service Enable And Start"

DOWNLOAD ${COMPONENT}

cd /tmp/mongodb-main
mongo < catalogue.js &>>{LOG_FILE} && mongo < users.js &>>{LOG_FILE}
STAT_CHECK $? "Load Schema"


