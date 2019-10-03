#!/bin/bash
if [[ $# -lt 5 ]] ; then
  printf '> bash '$0' <ami> <type> <secgroup> <tag> <ec2eip> <key-pair>\n'
  exit 1
fi

AMI_NAME=$1
EC2_TYPE=$2
EC2_SECGROUP=$3
EC2_TAG=$4
EC2_EIP=$5
EC2_KEY=$6

export AWS_ID=`aws sts get-caller-identity --query Account --output text`
printf '\nAccount: '$AWS_ID
export EC2_PROFILE="arn:aws:iam::"$AWS_ID":instance-profile/instance-role"
printf '\nInstance profile: '$EC2_PROFILE

export IAM_USER=`aws sts get-caller-identity --query UserId --output text`
printf '\nUsername: '$IAM_USER

printf "\nKey pair: "$EC2_KEY

export AMI_ID=`aws ec2 describe-images \
  --owners self \
  --output text \
  --query Images[0].[ImageId] \
  --filters Name=name,Values="$AMI_NAME"`
printf '\nAMI ID: '$AMI_ID

export SPOT_PRICE=`aws ec2 describe-spot-price-history \
  --no-paginate \
  --availability-zone ap-southeast-1a \
  --instance-types $EC2_TYPE \
  --product-descriptions "Linux/UNIX" \
  --output text \
  --query SpotPriceHistory[0].SpotPrice`
printf '\nSpot price: '$SPOT_PRICE

key=$(cat ~/.ssh/id_rsa.pub | xargs)

echo '#!/bin/bash' > raw.txt
raw='echo "'$key'" >> /home/ubuntu/.ssh/authorized_keys'

echo $raw >> raw.txt

echo '{' > launch-spec.json
echo "   \"ImageId\":\"$AMI_ID\"," >> launch-spec.json
echo "   \"InstanceType\":\"$EC2_TYPE\"," >> launch-spec.json
echo "   \"Placement\":{\"AvailabilityZone\": \"ap-southeast-1a\"}," >> launch-spec.json
echo "   \"IamInstanceProfile\": {\"Arn\": \"$EC2_PROFILE\"}," >> launch-spec.json
echo "   \"SecurityGroups\": [\"$EC2_SECGROUP\"]," >> launch-spec.json
echo "   \"KeyName\":\"$EC2_KEY\"" >> launch-spec.json
echo '}' >> launch-spec.json

export SPOT_REQ_ID=`aws ec2 request-spot-instances \
  --availability-zone-group ap-southeast-1a \
  --spot-price $SPOT_PRICE \
  --instance-count 1 \
  --instance-interruption-behavior stop \
  --type persistent \
  --query SpotInstanceRequests[0].SpotInstanceRequestId \
  --output text \
  --launch-specification file://launch-spec.json`
printf '\nSPOT_REQ_ID='$SPOT_REQ_ID

if [[ -z $SPOT_REQ_ID ]] ; then
  printf "\nUnable to fulfill request-spot-instances"
  exit 1
fi

sleep 5

export EC2_ID=`aws ec2 describe-spot-instance-requests \
  --query SpotInstanceRequests[0].InstanceId \
  --output text \
  --spot-instance-request-ids $SPOT_REQ_ID`
printf '\nEC2_ID='$EC2_ID

sleep 3

aws ssm put-parameter --name EC2_ID --value $EC2_ID --type String --overwrite
aws ssm put-parameter --name SPOT_REQ_ID --value $SPOT_REQ_ID --type String --overwrite

aws ec2 create-tags \
  --resources $SPOT_REQ_ID $EC2_ID \
  --tags Key=Name,Value="$EC2_TAG" \
         Key=Creator,Value="$IAM_USER"

if [[ -z $6 ]] ; then
  export EC2_ASSOC=`aws ec2 associate-address \
    --allocation-id $EC2_EIP \
    --instance-id $EC2_ID`

  printf '\nElastic IP Association ID='
  echo $EC2_ASSOC
fi

printf '\n'
