#!/bin/bash
if [[ -z $1 ]] ; then
  exit 1
fi

aws ec2 describe-images \
  --filters Name=name,Values=$1 \
  --output text \
  --query 'Images[0].ImageId'
