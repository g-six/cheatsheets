#!/bin/bash
export AWS_ID=`aws sts get-caller-identity --query Account --output text`
export IAM_USER=`aws sts get-caller-identity --query UserId --output text`
export EC2_PROFILE="arn:aws:iam::"$AWS_ID":instance-profile/instance-role"
export EC2_SECGROUP=secgroup-web
export AMI_ID=`aws ec2 describe-images \
  --owners self \
  --output text \
  --query Images[0].[ImageId] \
  --filters Name=name,Values="Node*,Ubuntu*"`
echo 'AMI ID: '$AMI_ID

export SPOT_PRICE=`aws ec2 describe-spot-price-history \
  --no-paginate \
  --availability-zone ap-southeast-1a \
  --instance-types $EC2_TYPE \
  --product-descriptions "Linux/UNIX" \
  --output text \
  --query SpotPriceHistory[0].SpotPrice`
echo 'Spot price: '$SPOT_PRICE

export SPOT_REQ_ID=`aws ec2 request-spot-instances \
  --availability-zone-group ap-southeast-1a \
  --spot-price $SPOT_PRICE \
  --instance-count 1 \
  --instance-interruption-behavior stop \
  --type persistent \
  --query SpotInstanceRequests[0].SpotInstanceRequestId \
  --output text \
  --launch-specification \
    "{ \
        \"ImageId\":\"$AMI_ID\", \
        \"InstanceType\":\"$EC2_TYPE\", \
        \"KeyName\":\"$EC2_KEY\", \
        \"Placement\":{\"AvailabilityZone\": \"ap-southeast-1a\"}, \
        \"IamInstanceProfile\": {\"Arn\": \"$EC2_PROFILE\"}, \
        \"SecurityGroups\": [\"$EC2_SECGROUP\"]
    }"`
echo 'SPOT_REQ_ID='$SPOT_REQ_ID
if [[ $SPOT_REQ_ID -eq "" ]] ; then
    exit 1
fi

sleep 5

export EC2_ID=`aws ec2 describe-spot-instance-requests \
  --query SpotInstanceRequests[0].InstanceId \
  --output text \
  --spot-instance-request-ids $SPOT_REQ_ID`
echo 'EC2_ID='$EC2_ID

sleep 3

aws ec2 create-tags \
  --resources $SPOT_REQ_ID $EC2_ID \
  --tags Key=Name,Value="$EC2_TAG" \
         Key=Creator,Value="$IAM_USER"

echo '\n'
