#!/bin/bash

echo "\e[1mMysql Setup\e[0m"

#etup MySQL Repo
## curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
#
#Install MySQL
## yum install mysql-community-server -y
#
#Start MySQL.
## systemctl enable mysqld
## systemctl start mysqld
#
#Now a default root password will be generated and given in the log file.
## grep temp /var/log/mysqld.log
#
#Next, We need to change the default root password in order to start using the database service.
## mysql_secure_installation
#
#You can check the new password working or not using the following command.
#
## mysql -u root -p
#
#Run the following SQL commands to remove the password policy.
#> uninstall plugin validate_password;
#Setup Needed for Application.
#As per the architecture diagram, MySQL is needed by
#
#Shipping Service
#So we need to load that schema into the database, So those applications will detect them and run accordingly.
#
#To download schema, Use the following command
#
## curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#Load the schema for Services.
#
## cd /tmp
## unzip mysql.zip
## cd mysql-main
## mysql -u root -pRoboShop@1 <shipping.sql




echo "\e[1mDownloading Mysql Repo\e[0m"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo  &>>{LOG_FILE}
STAT_CHECK $? "Downloading Mysql Repo"

echo "\e[1mInstalling Mysql\e[0m"
yum install mysql-community-server -y &>>{LOG_FILE}
STAT_CHECK $? "Installing Mysql"

echo "\e[1mService Enable And Start\e[0m"
systemctl enable mysqld &>LOG_FILE && systemctl start mysqld &>>{LOG_FILE}
STAT_CHECK $? "Service Enable And Start"


