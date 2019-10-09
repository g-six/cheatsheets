#!/bin/bash
if [ $# -lt 1 ] ; then
  printf "Please provide the proper tag\n\n"
  exit 1
fi

EC2_TAG=$1
printf "Retrieving instance information: $EC2_TAG\n\n"

AMI_ID=$(aws ec2 describe-images \
  --filters Name=name,Values=$EC2_TAG \
  --output text \
  --query 'Images[0].ImageId')
printf "+----------------------------------------------+\n"
printf "| AMI id        : $AMI_ID        | \n"

EC2_ID=$(aws ec2 describe-instances \
  --filters Name=tag:Name,Values=$EC2_TAG \
            Name=instance-state-name,Values=running \
  --output text \
  --query 'Reservations[0].Instances[0].InstanceId')
printf "| Instance id   : $EC2_ID          | \n"

SPOT_REQ_ID=$(aws ec2 describe-instances \
  --filters Name=tag:Name,Values=$EC2_TAG \
            Name=instance-state-name,Values=running \
  --output text \
  --query 'Reservations[0].Instances[0].SpotInstanceRequestId')
printf "| Spot instance : $SPOT_REQ_ID                 |\n"
printf "| request id                                   |\n"

printf "+----------------------------------------------+\n"
printf "\n"

AMI_STATE=$(aws ec2 describe-images --image-id $AMI_ID --query Images[0].State --output text)
if [[ $AMI_STATE = "available" ]] ; then
  printf "Deregistering $AMI_ID\n\n"
  aws ec2 deregister-image --image-id $AMI_ID
  AMI_STATE=pending
fi

while [[ $AMI_STATE = "pending" ]]
do
  sleep 5
  AMI_STATE=$(aws ec2 describe-images --image-id $AMI_ID --query Images[0].State --output text)
done

printf "Creating new image for $EC2_ID\n\n"
NEW_AMI_ID=$(aws ec2 create-image --instance-id $EC2_ID --name $EC2_TAG --query ImageId --output text)

AMI_STATE=pending

while [[ $AMI_STATE = 'pending' ]]
do
  sleep 5
  AMI_STATE=$(aws ec2 describe-images --image-id $NEW_AMI_ID --query Images[0].State --output text)
done

printf "$NEW_AMI_ID: $AMI_STATE\n\n"

if [ -z $NEW_AMI_ID ] ; then
  printf "Failed to create image.\nPlease try again.\n"
else
  printf "New ImageId: $NEW_AMI_ID\n"
fi

printf "Tearing down $EC2_ID\n"

if [[ -n $SPOT_REQ_ID ]] ; then
  printf "Cancelling spot request $SPOT_REQ_ID\n"
  aws ec2 cancel-spot-instance-requests \
    --spot-instance-request-ids $SPOT_REQ_ID
fi

if [[ -n $EC2_ID ]] ; then
  printf "Terminating $EC2_ID\n"
  aws ec2 terminate-instances --instance-ids $EC2_ID
fi

printf "\n"
