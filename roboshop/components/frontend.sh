#!/bin/bash

source components/common.sh

echo "Frontend Setup"
yum install nginx -y &>>{LOG_FILE}
STAT_CHECK $? "Nginx Installation"

echo "Download the frontend Content"
#curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>{LOG_FILE}
#STAT_CHECK $? "Download frontend Content"
DOWNLOAD ${COMPONENT}

echo "Remove All Files"
rm -rf /usr/share/nginx/html/* &>>{LOG_FILE}
STAT_CHECK $? "Remove All html content Files"

echo "Move files to nginx path"
mv /tmp/frontend-main/static/* /usr/share/nginx/html/. &>>{LOG_FILE}
STAT_CHECK $? "Move files to nginx path"

echo "Copy Roboshop Configuration File"
cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>{LOG_FILE}
STAT_CHECK $? "Copy Roboshop Configuration File"

echo "Enable Nginx"
systemctl enable nginx &>>{LOG_FILE}
STAT_CHECK $? "Enable Nginx"

echo "Start Nginx"
systemctl start nginx &>>{LOG_FILE}
STAT_CHECK $? "Start Nginx"

