#!/bin/bash
if [ $# -lt 1 ] ; then
  exit 1
fi

aws ec2 describe-instances \
  --filters Name=tag:Name,Values=$1 \
            Name=instance-state-name,Values=running \
  --output text \
  --query 'Reservations[0].Instances[0].SpotInstanceRequestId'
