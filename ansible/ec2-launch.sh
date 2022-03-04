#!/bin/bash

#aws ec2 request-spot-instances --instance-count 1 --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=frontend}]" --type "persistent" --launch-specification file://spot.json |jq

#aws ec2 run-instances --launch-specification file://spot.json |jq

TEMP_ID="lt-099eb0b79a90eeba3"
TEMP_NAME="my-spot-req"
TEMP_VER=8



aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} |jq