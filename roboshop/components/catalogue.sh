#!/bin/bash
source components/common.sh
MAX_LENGTH=$( cat ${0} components/common.sh |grep STAT_CHECK |grep -v -W cat |awk -F '"' '{print$2}' |awk '{print length}' |sort |tail -1 )

echo "Catalogue Setup"

# curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
STAT_CHECK $? "Install nodejs"

useradd roboshop &>>${LOG_FILE}
STAT_CHECK $? "Add Application User"

Download catalogue
