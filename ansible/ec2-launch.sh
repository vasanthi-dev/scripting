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
if [ -z "$1" ]; then
  echo "Input is missing"
  fi
COMPONENT=$1

aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservations[].Instances[].State.Name |sed 's/"//g' | grep -E 'running|stopped' &>/dev/null

if [ $? -eq 0 ]; then
  echo "Instance already exist"
  else
    aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${COMPONENT}}]" "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"  |jq
  fi










