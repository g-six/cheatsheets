#!/bin/bash
filter='--filter Name=name,Values='$1
if [ -z $1 ]
then
  filter=''
fi

output='--output '$2
if [ -z $2 ]
then
  output=''
fi


images=$(aws ec2 describe-images --owner self --query Images[*].[ImageId,Name] $filter $output)
Ymd=$(date +'%Y%m%d')

echo $images
