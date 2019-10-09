#!/bin/bash
SOURCE_REGION=ap-southeast-1
if [[ -n $3 ]] ; then
  SOURCE_REGION=$3
fi
aws ec2 copy-image --source-image-id $2 --source-region $SOURCE_REGION --name $1 \
  --output text
