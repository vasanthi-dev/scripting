#!/bin/bash

echo "\e[1mRabbitmq Installation\e[0m"


#Setup YUM repositories for RabbitMQ.
## curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
#Install RabbitMQ
## yum install rabbitmq-server -y
#Start RabbitMQ
## systemctl enable rabbitmq-server
## systemctl start rabbitmq-server
#RabbitMQ comes with a default username / password as guest/guest. But this user cannot be used to connect. Hence we need to create one user for the application.
#
#Create application user
## rabbitmqctl add_user roboshop roboshop123
## rabbitmqctl set_user_tags roboshop administrator
## rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

echo "\e[1mInstalling Erlang\e[0m"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y  &>>{LOG_FILE}
STAT_CHECK $? "Installing Erlang"

echo "\e[1mDownloading RabbitMQ Repo\e[0m"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo  &>>{LOG_FILE}
STAT_CHECK $? "Downloading RabbitMQ Repo"

echo "\e[1mInstalling RabbitMQ\e[0m"
yum install rabbitmq-server -y  &>>{LOG_FILE}
STAT_CHECK $? "Installing RabbitMQ"

echo"check Application user"
rabbitmqctl list_user | grep roboshop &>>{LOG_FILE}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop roboshop123
  STAT_CHECK $? "Create Application user in RabbitMQ"
  fi
echo "Configure App User Permissions"
rabbitmqctl set_user_tags roboshop administrator &>>{LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>{LOG_FILE}
STAT_CHECK $? "Configure App User Permissions"
