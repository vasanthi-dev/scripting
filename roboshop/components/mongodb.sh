#!/bin/bash

source components/common.sh
echo "Mongodb Setup"

echo "Downloading Mongodb Repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>{LOG_FILE}
STAT_CHECK $? "Downloading Mongodb Repo"

echo "Installing Mongodb"
yum install mongodb-org -y &>>{LOG_FILE}
STAT_CHECK $? "Installing Mongodb"

echo "Update Mongodb Service"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>{LOG_FILE}
STAT_CHECK $? "Update Mongodb Service"

echo "Service Enable And Start"
systemctl enable mongod &>LOG_FILE && systemctl start mongod &>>{LOG_FILE}
STAT_CHECK $? "Service Enable And Start"

DOWNLOAD ${COMPONENT}

cd /tmp/mongodb-main
mongo < catalogue.js &>>{LOG_FILE} && mongo < users.js &>>{LOG_FILE}
STAT_CHECK $? "Load Schema"


