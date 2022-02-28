#!/bin/bash
source components/common.sh
MAX_LENGTH=$( cat ${0} components/common.sh |grep STAT_CHECK |grep -v -W cat |awk -F '"' '{print$2}' |awk '{print length}' |sort |tail -1 )

echo "\e[1mReddis Installation\e[0m"

echo "\e[1mDownloading Reddis Repo\e[0m"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo  &>>${LOG_FILE}
STAT_CHECK $? "Downloading Reddis Repo"

echo "\e[1mInstalling Reddis\e[0m"
yum install redis -y  &>>${LOG_FILE}
STAT_CHECK $? "Installing Reddis"

echo "\e[1mUpdate Reddis Config\e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>${LOG_FILE}
STAT_CHECK $? "Update Reddis Config"

echo "\e[1mService Enable And Start\e[0m"
systemctl enable redis &>LOG_FILE && systemctl start redis &>>${LOG_FILE}
STAT_CHECK $? "Service Enable And Start"