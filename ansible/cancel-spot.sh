#!/bin/bash


#aws ec2 describe-spot-instance-requests --filters "Name=tag:Name,Values=${comp}" --query "SpotInstanceRequests[*].[InstanceId]"


  for comp in test workstation ; do
  SPOT_INSTANCE_ID=$(aws ec2 describe-spot-instance-requests --filters "Name=tag:Name,Values=${comp}" --query "SpotInstanceRequests[*].[InstanceId]" |jq)

  echo "${SPOT_INSTANCE_ID}"



  done

