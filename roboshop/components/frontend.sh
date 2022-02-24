#!/bin/bash

source components/commons.sh

echo "Frontend Setup"
yum install nginx -y &>>LOG_FILE
STAT_CHECK $? "Nginx Installation"
echo "Download the Content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>LOG_FILE
STAT_CHECK $? "Download frontend Content"
echo "Remove All Files"
rm -rf /usr/share/nginx/html/* &>>LOG_FILE
STAT_CHECK $? "Remove All html content Files"

echo "Unzip the Folder"
unzip -o -d /tmp /tmp/frontend.zip &>>LOG_FILE
STAT_CHECK $? "unzip the folder to tmp loacation"

echo "Move files to nginx path"
mv /tmp/frontend-main/static/* /usr/share/nginx/html/.
STAT_CHECK $? "Move files to nginx path"

echo "Copy Roboshop Configuration File"
cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT_CHECK $? "Copy Roboshop Configuration File"


echo "Enable Nginx"
systemctl enable nginx
STAT_CHECK $? "Enable Nginx"

echo "Start Nginx"
systemctl start nginx
STAT_CHECK $? "Start Nginx"

#echo "Move the folder to current location"
#mv frontend-main/* .
#mv static/* .
#
#echo "Remove the files which are not used"
#rm -rf frontend-master static README.md
#
#echo "Move local Configuration to webserver location"
#mv localhost.conf /etc/nginx/default.d/roboshop.conf