#!/bin/bash
if [[ $# -ne 5 ]] ; then
  printf '> bash '$0' <ami> <type> <secgroup> <key-pair> <tag>\n'
  exit 1
fi

AMI_NAME=$1
EC2_TYPE=$2
EC2_SECGROUP=$3
EC2_KEY=$4
EC2_TAG=$5

export AWS_ID=`aws sts get-caller-identity --query Account --output text`
printf 'Account: '$AWS_ID
export EC2_PROFILE="arn:aws:iam::"$AWS_ID":instance-profile/instance-role"
printf 'Instance profile: '$EC2_PROFILE

export IAM_USER=`aws sts get-caller-identity --query UserId --output text`
printf 'Username: '$IAM_USER

printf "Key pair: "$EC2_KEY

export AMI_ID=`aws ec2 describe-images \
  --owners self \
  --output text \
  --query Images[0].[ImageId] \
  --filters Name=name,Values="$AMI_NAME"`
printf 'AMI ID: '$AMI_ID

export SPOT_PRICE=`aws ec2 describe-spot-price-history \
  --no-paginate \
  --availability-zone ap-southeast-1a \
  --instance-types $EC2_TYPE \
  --product-descriptions "Linux/UNIX" \
  --output text \
  --query SpotPriceHistory[0].SpotPrice`
printf 'Spot price: '$SPOT_PRICE

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
        \"SecurityGroups\": [\"$EC2_SECGROUP\"], \
        \"UserData\": \"$EC2_B64\"
    }"`
printf 'SPOT_REQ_ID='$SPOT_REQ_ID
if [[ -z $SPOT_REQ_ID ]] ; then
  printf "Unable to fulfill request-spot-instances"
  exit 1
fi

sleep 5

export EC2_ID=`aws ec2 describe-spot-instance-requests \
  --query SpotInstanceRequests[0].InstanceId \
  --output text \
  --spot-instance-request-ids $SPOT_REQ_ID`
printf 'EC2_ID='$EC2_ID

sleep 3

aws ec2 create-tags \
  --resources $SPOT_REQ_ID $EC2_ID \
  --tags Key=Name,Value="$EC2_TAG" \
         Key=Creator,Value="$IAM_USER"

export EC2_ASSOC=`aws ec2 associate-address \
	--allocation-id $EC2_EIP \
	--instance-id $EC2_ID`

printf 'Elastic IP Association ID='$EC2_ASSOC

printf '\n'
