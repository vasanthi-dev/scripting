#!/bin/bash
source components/common.sh
echo "\e[1mRabbitmq Installation\e[0m"
#MAX_LENGTH=$( cat ${0} components/common.sh |grep STAT_CHECK |grep -v -W cat |awk -F '"' '{print$2}' |awk '{print length}' |sort |tail -1 )

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG_FILE}
STAT_CHECK $? "Download RabbitMQ Repo"

yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>${LOG_FILE}
STAT_CHECK $? "Install Erlang & RabbitMQ"

systemctl enable rabbitmq-server &>>${LOG_FILE}  && systemctl start rabbitmq-server &>>${LOG_FILE}

rabbitmqctl  list_users | grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
  STAT_CHECK $? "Create APp User in RabbitMQ"
fi

rabbitmqctl set_user_tags roboshop administrator  &>>${LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>${LOG_FILE}
STAT_CHECK $? "Configure APp User Permissions"

