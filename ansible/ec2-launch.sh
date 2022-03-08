#!/bin/bash

#normal instance creation
# aws ec2 request-spot-instances --instance-count 1 --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=frontend}]" --type "persistent" --launch-specification file://spot.json |jq

#create instance from launch template
#aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=frontend}]" "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}]"  |jq

#aws ec2 run-instances --launch-specification file://spot.json |jq

#Describe instance check instance exit or not
# aws ec2 describe-instances --filters "Name=tag:Name,Values= frontend --query Reservations[].Instances[].
#
# COUNT=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=workstation" | jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | wc -l)

 #otherway to GET IPADDRESS AND eleminate Double quotes
  # IPADDRESS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq ".Reservations[].Instances[].PrivateIpAddress" |grep -v null | sed 's/"//g')



TEMP_ID="lt-099eb0b79a90eeba3"
TEMP_NAME="my-spot-req"
TEMP_VER=8
ZONE_ID="Z01304753HAJF01BJ7NCL"

if [ -z "$1" ]; then
  echo -e  "\e[1;31mInput is missing\e[0m"
  exit 1
  fi

COMPONENT=$1
ENV=$2

if [ ! -z "$ENV" ]; then
  ENV="-${ENV}"
  fi

CREATE_INSTANCE(){
  #checking instance exists or not
  aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservations[].Instances[].State.Name |sed 's/"//g' | grep -E 'running|stopped' &>/dev/null

  if [ $? -eq -0 ]; then
    echo -e "\e[1;33mInstance already exist\e[0m"
   else
     #create instance from launch template
     aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${COMPONENT}}]" "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"  |jq
     sleep 10
    fi
# update dns record
  IPADDRESS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq ".Reservations[].Instances[].PrivateIpAddress" |grep -v null |xargs)

  sed -e "s/IPADDRESS/${IPADDRESS}/" -e "s/COMPONENT/${COMPONENT}.roboshop.internal/" dnsrecord.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json | jq
}

if [ "${COMPONENT}" == "all" ]; then
  for comp in frontend$ENV mongodb$ENV user$ENV catalogue$ENV mysql$ENV redis$ENV cart$ENV shipping$ENV payment$ENV rabbitmq$ENV dispatch$ENV; do
  COMPONENT=${comp}
  CREATE_INSTANCE
  done
  else
    COMPONENT=$COMPONENT$ENV
  CREATE_INSTANCE
  fi



#aws ec2 cancel-spot-instance-requests --filters "Name=tag:Name,Values=test" | jq
#
#--spot-instance-request-ids
#
#aws ec2 describe-spot-instance-requests --filters "Name=state,Values=active" | jq
#
#
#
#aws ec2 describe-spot-instance-requests --filters "Name=tag:Name,Values=${comp}" --query "SpotInstanceRequests[*].[InstanceId]"