#!/bin/bash

LOG_FILE=/tmp/roboshop.log
rm -rf ${LOG_FILE}

MAX_LENGTH=$( cat components/*.sh |grep STAT_CHECK |grep -v -W cat |awk -F '"' '{print$2}' |awk '{print length}' |sort |tail -1 )

if [ MAX_LENGTH -lt 24 ]; then
  MAX_LENGTH=24
  fi

STAT_CHECK() {
  SPACE=""
#MIN_LENGTH=$(grep STAT_CHECK |awk -F '"' '{print$2}' |awk '{print length}')
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

DOWNLOAD() {
  curl -s -o /tmp "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
  STAT_CHECK $? "Download ${COMPONENT} Code"
  unzip -o -d /tmp /tmp/${COMPONENT}.zip &>>${LOG_FILE}
  STAT_CHECK $? "Extract ${COMPONENT} Code"
}

NODEJS() {
  yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
  STAT_CHECK $? "Install nodejs"

  id roboshop &>>${LOG_FILE}
  if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG_FILE}
  STAT_CHECK $? "Add Application User"
  fi

  Download ${1}

  mv /tmp/${1}-main/* /home/roboshop/${1}
  STAT_CHECK $? "Move Catalogue Content"
  cd /home/roboshop/${1} && npm install --unsafe-perm &>>${LOG_FILE}
  STAT_CHECK $? "Install NodeJs Dependencies"

  chown roboshop:roboshop -R /home/roboshop

  sed -i -e 's/MONGO_DNSNAME/mongo.roboshop.internal/' /home/roboshop/${1}/systemd.service && mv /home/roboshop/${1}/systemd.service /etc/systemd/system/${1}.service &>>${LOG_FILE}
  STAT_CHECK $? "Updated DNSNAME in SystemD"

  echo "\e[1mService Enable And Start\e[0m"
  systemctl daemon-reload &>>${LOG_FILE} && systemctl enable ${1} &>>${LOG_FILE} && systemctl start ${1} &>>${LOG_FILE}
  STAT_CHECK $? "Start ${1} Service"

}



