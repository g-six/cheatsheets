#!/bin/bash
aws ec2 describe-images \
  --output text \
  --query Images[0].State \
  --image-id $1
