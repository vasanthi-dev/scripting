#!/bin/bash

#aws ec2 request-spot-instances --instance-count 1 --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=frontend}]" --type "persistent" --launch-specification file://spot.json |jq

#aws ec2 run-instances --launch-specification file://spot.json |jq


aws ec2 run-instances --launch-template LaunchTemplateId="lt-099eb0b79a90eeba3",LaunchTemplateName="my-spot-req",Version="8" |jq