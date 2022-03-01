#!/bin/bash

source components/common.sh

#MAX_LENGTH=$( cat ${0} components/common.sh |grep STAT_CHECK |grep -v -W cat |awk -F '"' '{print$2}' |awk '{print length}' |sort |tail -1 )

echo "\e[1mFrontend Installation\e[0m"
echo "\e[1mNginx Installation\e[0m"
yum install nginx -y &>>${LOG_FILE}
STAT_CHECK $? "Nginx Installation"

echo "\e[1mDownload the frontend Content\e[0m"
#curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>${LOG_FILE}
#STAT_CHECK $? "Download frontend Content"
DOWNLOAD ${COMPONENT}

echo "\e[1mRemove All Files\e[0m"
rm -rf /usr/share/nginx/html/* &>>${LOG_FILE}
STAT_CHECK $? "Remove All html content Files"

echo "\e[1mMove files to nginx path\e[0m"
mv /tmp/frontend-main/static/* /usr/share/nginx/html/. &>>${LOG_FILE}
STAT_CHECK $? "Move files to nginx path"

echo "\e[1mCopy Roboshop Configuration File\e[0m"
cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}
STAT_CHECK $? "Copy Roboshop Configuration File"

echo "\e[1mEnable Nginx\e[0m"
systemctl enable nginx &>>${LOG_FILE}
STAT_CHECK $? "Enable Nginx"

echo "\e[1mStart Nginx\e[0m"
systemctl start nginx &>>${LOG_FILE}
STAT_CHECK $? "Start Nginx"

