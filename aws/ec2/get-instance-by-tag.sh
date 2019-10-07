#!/bin/bash
aws ec2 describe-instances \
	--filter Name=$1,Values=$2 \
  --query 'Reservations[*].Instances[0]'$3

# [NetworkInterfaces[0].[Association.PublicIp],InstanceId,SpotInstanceRequestId]
