#!/bin/bash
if [[ -z $1 ]] ; then
  exit 1
fi

AMI_ID=$1
AMI_STATE=$(bash ./get-image-state.sh $AMI_ID)
if [[ $AMI_STATE = "available" ]] ; then
  aws ec2 deregister-image --image-id $AMI_ID
  AMI_STATE=pending
fi

while [[ $AMI_STATE = "pending" ]]
do
  sleep 3
  AMI_STATE=$(bash ./get-image-state.sh $AMI_ID)
done

echo $AMI_STATE
