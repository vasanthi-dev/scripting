#!/bin/bash

echo "Frontend Setup"

#echo "Installing Nginx"
#
#yum install nginx -y
#
#echo "Enable Nginx"
#
#systemctl enable nginx
#
#echo "Start Nginx"
#
#systemctl start nginx
#
#echo Download the Content
#
#curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
#
#echo Deploy in Nginx Default Location
#
#cd /usr/share/nginx/html
#
#echo "Remove All Files"
#
#rm -rf *
#
#echo "Unzip the Folder"
#
#unzip /tmp/frontend.zip
#
#echo "Move the folder to current location"
#mv frontend-main/* .
#mv static/* .
#
#echo "Remove the files which are not used"
#rm -rf frontend-master static README.md
#
#echo "Move local Configuration to webserver location"
#mv localhost.conf /etc/nginx/default.d/roboshop.conf
