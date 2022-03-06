#!/bin/bash


#aws ec2 describe-spot-instance-requests --filters "Name=tag:Name,Values=${comp}" --query "SpotInstanceRequests[*].[InstanceId]"


  for comp in test test2 ; do
  SPOT_INSTANCE_ID=$(aws ec2 describe-spot-instance-requests --filters "Name=tag:Name,Values=${comp}" --query "SpotInstanceRequests[*].[SpotInstanceRequestId]" |jq)

  echo "${SPOT_INSTANCE_ID}"

  aws ec2 cancel-spot-instance-requests --spot-instance-request-ids "${SPOT_INSTANCE_ID}"

  done



