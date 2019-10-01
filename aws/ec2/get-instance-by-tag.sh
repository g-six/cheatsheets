#!/bin/bash
aws ec2 describe-instances \
	--filter Name=tag:$1,Values=$2 \
  --query 'Reservations[0].Instances[0]'$3
