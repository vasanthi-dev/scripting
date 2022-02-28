#!/bin/bash
source components/common.sh
echo "\e[1mMysql Setup\e[0m"
MAX_LENGTH=$( cat $0 |grep STAT_CHECK |grep -v cat |awk -F '"' '{print$2}' |awk '{print length}' |sort |tail -1 )

#setup MySQL Repo
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
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo  &>>${LOG_FILE}
STAT_CHECK $? "Downloading Mysql Repo"

echo "\e[1mInstalling Mysql\e[0m"
yum install mysql-community-server -y &>>${LOG_FILE}
STAT_CHECK $? "Installing Mysql"

echo "\e[1mService Enable And Start\e[0m"
systemctl enable mysqld &>LOG_FILE && systemctl start mysqld &>>${LOG_FILE}
STAT_CHECK $? "Service Enable And Start"

DEFAULT_PASS=$(grep 'temporary password' /var/log/mysqld.log |awk '{print $NF}')
echo 'show databases;' | mysql -uroot -pRoboshop@1 &>>${LOG_FILE}
if [ $? -ne 0 ]; then
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" >/tmp/pass.sql
mysql --connect-expired-password -uroot -p"${DEFAULT_PASS}" </tmp/pass.sql &>>${LOG_FILE}
STAT_CHECK $? "Setup new root password"
fi

echo 'show plugins;'  |mysql -uroot -pRoboshop@1 2>>${LOG_FILE} |grep validate_password &>>${LOG_FILE}

if [ $? -eq 0 ]; then
  echo 'uninstall plugin validate_password;' | mysql -uroot -pRoboShop@1 &>>${LOG_FILE}
   STAT_CHECK $? "Uninstall Password Plugin"
fi

DOWNLOAD mysql

cd /tmp/mysql-main
mysql -u root -pRoboShop@1 <shipping.sql &>>${LOG_FILE}
STAT_CHECK $? "Load Schema"
