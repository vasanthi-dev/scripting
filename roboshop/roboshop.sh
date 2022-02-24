#!/bin/bash

#source components/

USER_UID=$(id -u)
if [ "${USER_UID}" -ne 0 ]; then
   echo -e "\e[1;31myou should be a root user to perform this script\e[0m"
   exit
fi

COMPONENT=$1
if [ -z "${COMPONENT}" ]; then
  echo -e "\e[1;31mMissing Component Input\e[0m"
  exit
fi

if [ ! -e components/${COMPONENT}.sh ]; then
  echo -e "\e[0mGiven Component script does not exists\e[0m"
  exit
fi

path=components/${COMPONENT}.sh

bash ${path}