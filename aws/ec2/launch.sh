#!/bin/bash
export AWS_ID=`aws sts get-caller-identity --query Account --output text`
export EC2_PROFILE="arn:aws:iam::"$AWS_ID":instance-profile/instance-role"
export EC2_SECGROUP=secgroup-windows

export SPOT_PRICE=`aws ec2 describe-spot-price-history \
  --no-paginate \
  --availability-zone ap-southeast-1a \
  --instance-types $EC2_TYPE \
  --product-descriptions Windows \
  --output text \
  --query SpotPriceHistory[0].SpotPrice`

aws ec2 request-spot-instances \
  --spot-price $SPOT_PRICE \
  --instance-count 1 \
  --region ap-southeast-1 \
  --instance-interruption-behavior stop \
  --type persistent \
  --launch-specification \
    "{ \
        \"ImageId\":\"$AMI_ID\", \
        \"InstanceType\":\"t3a.large\", \
        \"KeyName\":\"$EC2_KEY\", \
        \"IamInstanceProfile\": {\"Arn\": \"$EC2_PROFILE\"}, \
        \"SecurityGroups\": [\"$EC2_SECGROUP\"]
    }"

echo 'Spot price: '$SPOT_PRICE
echo '\n'
