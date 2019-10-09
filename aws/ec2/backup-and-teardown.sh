#!/bin/bash
if [ $# -lt 1 ] ; then
  printf "Please provide the proper tag\n\n"
  exit 1
fi

EC2_TAG=$1
printf "Retrieving instance information: $EC2_TAG\n\n"

AMI_ID=$(bash ./get-image-id.sh $EC2_TAG)
EC2_ID=$(bash ./get-instance-id.sh $EC2_TAG)

if [[ $EC2_ID = 'None' ]] ; then
  printf "No running instance to terminate...\n\n"
  exit 1
fi
if [[ -z $EC2_ID ]] ; then
  printf "No running instance to terminate...\n\n"
  exit 1
fi

printf "+----------------------------------------------+\n"
printf "| AMI id        : $AMI_ID        | \n"
printf "+----------------------------------------------+\n"

printf "| Instance id   : $EC2_ID          | \n"
printf "+----------------------------------------------+\n"

SPOT_REQ_ID=$(bash ./get-spot-request-id.sh $EC2_TAG)
printf "| Spot instance : $SPOT_REQ_ID                 |\n"
printf "| request id                                   |\n"
printf "+----------------------------------------------+\n"

printf "\n"

AMI_STATE=$(bash ./get-image-state.sh $AMI_ID)
if [[ $AMI_STATE = "available" ]] ; then
  printf "Deregistering $AMI_ID\n\n"
  aws ec2 deregister-image --image-id $AMI_ID
  AMI_STATE=pending
fi

while [[ $AMI_STATE = "pending" ]]
do
  printf '* '
  sleep 5
  AMI_STATE=$(bash ./get-image-state.sh $AMI_ID)
done
printf "\nDone!\n\n"

printf "Creating new image for $EC2_ID\n\n"
NEW_AMI_ID=$(bash ./create-image.sh $EC2_TAG $EC2_ID)
AMI_STATE=pending
while [[ $AMI_STATE = "pending" ]]
do
  printf '* '
  sleep 5
  AMI_STATE=$(bash ./get-image-state.sh $NEW_AMI_ID)
done

if [ -z $NEW_AMI_ID ] ; then
  printf "Failed to create image.\nPlease try again.\n"
  exit 1
else
  printf "New ImageId: $NEW_AMI_ID\n"
fi

printf "Tearing down $EC2_ID\n"

if [[ -n $SPOT_REQ_ID ]] ; then
  printf "Cancelling spot request $SPOT_REQ_ID\n"
  bash ./cancel-spot.sh $SPOT_REQ_ID
fi

if [[ -n $EC2_ID ]] ; then
  printf "Terminating $EC2_ID\n"
  bash ./terminate.sh $EC2_ID
fi

printf "\n"
