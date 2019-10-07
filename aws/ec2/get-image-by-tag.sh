#!/bin/bash
aws ec2 describe-images --owner self --filters Name=$1,Values=$2 --output text --query Images[0].ImageId
