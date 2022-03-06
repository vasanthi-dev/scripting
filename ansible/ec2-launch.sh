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



TEMP_ID="lt-099eb0b79a90eeba3"
TEMP_NAME="my-spot-req"
TEMP_VER=8
ZONE_ID="Z01304753HAJF01BJ7NCL"

if [ -z "$1" ]; then
  echo -e  "\e[1;31mInput is missing\e[0m"
  exit 1
  fi

COMPONENT=$1

aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservations[].Instances[].State.Name |sed 's/"//g' | grep -E 'running|stopped' &>/dev/null

if [ $? -eq -0 ]; then
  echo -e "\e[1;33mInstance already exist\e[0m"
 else
   aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${COMPONENT}}]" "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"  |jq
  fi

IPADDRESS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq ".Reservations[].Instances[].PrivateIpAddress" |grep -v null |xargs)

echo "${IPADDRESS}"

#otherway to eleminate Double quotes
# IPADDRESS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq ".Reservations[].Instances[].PrivateIpAddress" |grep -v null | sed 's/"//g')

sed -e 's/IPADDRESS/${IPADDRESS}/' -e 's/COMPONENT/${COMPONENT}/' dnsrecord.json >/tmp/record.json

cat /tmp/record.json

aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json | jq








