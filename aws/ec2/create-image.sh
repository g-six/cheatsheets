#!/bin/bash
if [[ $# -lt 2 ]] ; then
  exit 1
fi

aws ec2 create-image --instance-id $2 --name $1 --query ImageId --output text
