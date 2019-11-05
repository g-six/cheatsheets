#!/bin/bash
id=$1
if [ -z $1 ]; then
  id=$(cat added-id.txt | xargs)
fi
aws ec2 release-address --allocation-id $id
rm added-id.txt
