#!/bin/bash

LOG_FILE=/tmp/roboshop.log
rm -rf ${LOG_FILE}

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




