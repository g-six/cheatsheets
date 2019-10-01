#!/bin/bash
images=$(aws ec2 describe-images --owner self --query Images[*].[ImageId,Name] --output text)
Ymd=$(date +'%Y%m%d')

echo $images
