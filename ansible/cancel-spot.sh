#!/bin/bash

STATUS="active"
  for comp in test1 test2 ; do
  SPOT_INSTANCE_ID=$(aws ec2 describe-spot-instance-requests --filters Name=tag:Name,Values=${comp} Name=state,Values=${STATUS}|jq ".SpotInstanceRequests[].SpotInstanceRequestId" |xargs)
  INSTANCE_ID=$(aws ec2 describe-spot-instance-requests --filters Name=tag:Name,Values=${comp} Name=state,Values=${STATUS}|jq ".SpotInstanceRequests[].InstanceId" |xargs)
  echo "${SPOT_INSTANCE_ID}"
   echo "${INSTANCE_ID}"
  aws ec2 cancel-spot-instance-requests --spot-instance-request-ids "${SPOT_INSTANCE_ID}"
  aws ec2 terminate-instances --instance-ids "${INSTANCE_ID}"
  done
