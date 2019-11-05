#!/bin/bash
aws ec2 allocate-address > added-ip.txt
ID=$(awk -F'[[:space:]]*:[[:space:]]*' '/^[[:space:]]*"AllocationId"/{ print $2 }' added-ip.txt | tr '"' ' ' | tr ',' ' ' | xargs)
IPADDR=$(awk -F'[[:space:]]*:[[:space:]]*' '/^[[:space:]]*"PublicIp"/{ print $2 }' added-ip.txt | tr '"' ' ' | tr ',' ' ' | xargs)
echo $IPADDR > added-ip.txt
echo $ID > added-id.txt

cat added-ip.txt
