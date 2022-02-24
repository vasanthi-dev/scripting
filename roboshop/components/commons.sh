#!/bin/bash
LOG_FILE=/tmp/roboshop.log
rm -rf ${LOG_FILE}

STAT_CHECK(){
  if [ $1 -gt 0 ]; then
    echo -e "\e[1;31m$2 - Failed\e[0m"
    exit 1
    else
      echo -e "\e[1;32m$2 - Success\e[0m"
    fi

}