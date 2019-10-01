#!/bin/bash
aws ec2 describe-addresses --filters Name=tag:$1,Values=$2 --query Addresses[0].AllocationId | xargs
