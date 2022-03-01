#!/bin/bash
source components/common.sh
echo "\e[1mRabbitmq Installation\e[0m"
#MAX_LENGTH=$( cat ${0} components/common.sh |grep STAT_CHECK |grep -v -W cat |awk -F '"' '{print$2}' |awk '{print length}' |sort |tail -1 )

echo "\e[1mInstalling Erlang\e[0m"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y  &>>${LOG_FILE}
STAT_CHECK $? "Installing Erlang"

echo "\e[1mDownloading RabbitMQ Repo\e[0m"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo  &>>${LOG_FILE}
STAT_CHECK $? "Downloading RabbitMQ Repo"

echo "\e[1mInstalling RabbitMQ\e[0m"
yum install rabbitmq-server -y  &>>${LOG_FILE}
STAT_CHECK $? "Installing RabbitMQ"

echo"check Application user"
rabbitmqctl list_user | grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop roboshop123
  STAT_CHECK $? "Create Application user in RabbitMQ"
  fi
echo "Configure App User Permissions"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG_FILE}
STAT_CHECK $? "Configure App User Permissions"
