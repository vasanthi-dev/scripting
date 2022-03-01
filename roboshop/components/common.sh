#!/bin/bash

LOG_FILE=/tmp/roboshop.log
rm -rf ${LOG_FILE}

MAX_LENGTH=$( cat components/*.sh |grep STAT_CHECK |grep -v cat |awk -F '"' '{print $2}' |awk '{print length}' |sort |tail -1 )

if [ ${MAX_LENGTH} -lt 24 ]; then
  MAX_LENGTH=24
  fi

STAT_CHECK() {
  SPACE=""
#MIN_LENGTH=$(grep STAT_CHECK |awk -F '"' '{print $2}' |awk '{print length}')
  MIN_LENGTH=$(echo $2 |awk '{print length}')
  LEFT=$((${MAX_LENGTH}-${MIN_LENGTH}))
  while [ ${LEFT} -gt 0 ]; do
    SPACE=$(echo -n "${SPACE} ")
    LEFT=$((${LEFT}-1))
  done
  if [ $1 -ne 0 ]; then
    echo -e "\e[1m$2 - \e[1;31mFailed\e[0m"
    exit 1
    else
      echo -e "\e[1m$2 - \e[1;32mSuccess\e[0m"
    fi
}

set-hostname -skip-apply ${COMPONENT}

SYSTEMD_SETUP() {

  chown roboshop:roboshop -R /home/roboshop
    sed -i -e 's/MONGO_DNSNAME/mongod.roboshop.internal/' \
           -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' \
           -e 's/MONGO_ENDPOINT/mongod.roboshop.internal/'  \
           -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/'\
           -e 's/CARTENDPOINT/cart.roboshop.internal/'\
           -e 's/DBHOST/mysql.roboshop.internal/' \
           -e 's/CARTHOST/cart.roboshop.internal/'\
           -e 's/USERHOST/user.roboshop.internal/'\
           -e 's/AMQPHOST/rabbitmq.roboshop.internal/'\
           -e 's/RABBITMQ-IP/rabbitmq.roboshop.internal/' /home/roboshop/${component}/systemd.service && mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service &>>${LOG_FILE}
    STAT_CHECK $? "Updated DNSNAME in SystemD"

  echo -e "\e[1mService Enable And Start\e[0m"
  systemctl daemon-reload &>>${LOG_FILE} && systemctl restart ${component} &>>${LOG_FILE} && systemctl enable ${component} &>>${LOG_FILE}
  STAT_CHECK $? "Start ${component} Service"

}

DOWNLOAD() {
 curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip" &>>${LOG_FILE}
   STAT_CHECK $? "Download ${1} Code"
   cd /tmp
   unzip -o /tmp/${1}.zip &>>${LOG_FILE}
   STAT_CHECK $? "Extract ${1} Code"
   if [ ! -z "${component}" ]; then
     rm -rf /home/roboshop/${component} && mkdir -p /home/roboshop/${component} && cp -r /tmp/${component}-main/* /home/roboshop/${component} &>>${LOG_FILE}
     STAT_CHECK $? "Copy ${component} Content"
   fi
}

APP_USER_SETUP(){
 id roboshop &>>${LOG_FILE}
    if [ $? -ne 0 ]; then
    useradd roboshop &>>${LOG_FILE}
    STAT_CHECK $? "Add Application User"
    fi
DOWNLOAD ${component}
}

NODEJS() {
  # session 18 last to\
  component=${1}
  curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>${LOG_FILE}
  yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
  STAT_CHECK $? "Install nodejs"

 APP_USER_SETUP

  cd /home/roboshop/${1} && npm install --unsafe-perm &>>${LOG_FILE}
  STAT_CHECK $? "Install NodeJs Dependencies"

  SYSTEMD_SETUP
}

JAVA() {
  component=${1}
  yum install maven -y &>>${LOG_FILE}
  STAT_CHECK $? "Install Maven"

  APP_USER_SETUP

  cd /home/roboshop/${component} && mvn clean package &>>{LOG_FILE} && mv target/${component}-1.0.jar ${component}.jar &>>{LOG_FILE}
  STAT_CHECK $? "Compile Java Code"

  SYSTEMD_SETUP

}

python() {
component=${1}
  yum install python36 gcc python3-devel -y &>>{LOG_FILE}
  STAT_CHECK $? "Installing Python"
  APP_USER_SETUP
  cd /home/roboshop/${component}  && pip3 install -r requirements.txt &>>{LOG_FILE}
  STAT_CHECK $? "Install Python Dependencies"
  SYSTEMD_SETUP
}

GOLANG() {
component=${1}
  yum install golang -y &>>{LOG_FILE}
  STAT_CHECK $? "Installing Golang"
  APP_USER_SETUP
  cd /home/roboshop/${component}  && go mod init dispatch &>>{LOG_FILE} && go get &>>{LOG_FILE} && go build &>>{LOG_FILE}
  STAT_CHECK $? "Install Golang Dependencies & Compile"
  SYSTEMD_SETUP
}




