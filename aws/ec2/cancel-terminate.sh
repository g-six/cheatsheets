#!/bin/bash
source ./.exports

printf "$HEADER\n\n\n"

if [[ $# -ne 2 ]] ; then
  printf "${CYAN}Usage:${NC} bash "$0' $SPOT_REQ_ID $EC2_ID\n\n'
  exit 1
fi

aws ec2 cancel-spot-instance-requests --spot-instance-request-ids $1
aws ec2 terminate-instances --instance-ids $2
