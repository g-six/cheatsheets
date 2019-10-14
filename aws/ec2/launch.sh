#!/bin/bash
if [[ $# -lt 2 ]] ; then
  printf '> bash '$0' <tag> <secgroup> [instance-type] [ec2eip] [key-pair]\n'
  exit 1
fi

EC2_TAG=$1
EC2_SECGROUP=$2
EC2_TYPE=$3
EC2_EIP=$4
EC2_KEY=$5

if [[ $# -lt 3 ]] ; then
  EC2_TYPE=t3a.micro
fi

bash ./header-runner.sh
printf "\n"

if [[ -z $4 ]] ; then
  printf "No Elastic IP provided, searching EIP tagged $EC2_TAG...\n"
  export EC2_EIP=$(aws ec2 describe-addresses --filters Name=tag:Name,Values=$EC2_TAG --query Addresses[0].AllocationId --output text)
  if [[ $EC2_EIP = "None" ]] ; then
    printf 'No Elastic IP found\n'
    unset EC2_EIP
  else
    printf "Elastic IP found: $EC2_EIP\n"
  fi
fi

printf "\n"

if [ -z $EC2_KEY ] ; then
  bash ./build-user-data.sh
  export USER_DATA=$(base64 raw.txt | xargs)

  printf "Attach user data:\n$USER_DATA\n\n"
else
  printf "Key pair: $EC2_KEY\n\n"
fi

export AWS_ID=`aws sts get-caller-identity --query Account --output text`
printf '\nAccount: '$AWS_ID
export EC2_PROFILE="arn:aws:iam::"$AWS_ID":instance-profile/instance-role"
printf '\nInstance profile: '$EC2_PROFILE

export IAM_USER=`aws sts get-caller-identity --query UserId --output text`
printf '\nUsername: '$IAM_USER

export AMI_ID=`aws ec2 describe-images \
  --owners self \
  --output text \
  --query Images[0].[ImageId] \
  --filters Name=name,Values="$EC2_TAG"`
printf '\nAMI ID: '$AMI_ID

export SPOT_PRICE=`aws ec2 describe-spot-price-history \
  --no-paginate \
  --availability-zone ap-southeast-1a \
  --instance-types $EC2_TYPE \
  --product-descriptions "Linux/UNIX" \
  --output text \
  --query SpotPriceHistory[0].SpotPrice`
printf '\nSpot price: '$SPOT_PRICE

echo '{' > launch-spec.json
echo "   \"ImageId\":\"$AMI_ID\"" >> launch-spec.json
echo "   ,\"InstanceType\":\"$EC2_TYPE\"" >> launch-spec.json
echo "   ,\"Placement\":{\"AvailabilityZone\": \"ap-southeast-1a\"}" >> launch-spec.json
echo "   ,\"IamInstanceProfile\": {\"Arn\": \"$EC2_PROFILE\"}" >> launch-spec.json
echo "   ,\"SecurityGroups\": [\"$EC2_SECGROUP\"]" >> launch-spec.json
if [ "$USER_DATA" ] ; then
  echo "   ,\"UserData\": \"$USER_DATA\"" >> launch-spec.json
fi

if [ "$EC2_KEY" ] ; then
  echo "   ,\"KeyName\":\"$EC2_KEY\"" >> launch-spec.json
fi

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

while [[ -z $EC2_ID ]]
do
  sleep 3
  EC2_ID=`aws ec2 describe-spot-instance-requests \
    --query SpotInstanceRequests[0].InstanceId \
    --output text \
    --spot-instance-request-ids $SPOT_REQ_ID`
done

printf '\nEC2_ID='$EC2_ID

INSTANCE_STATE=`aws ec2 describe-instances \
  --instance-ids $EC2_ID \
  --query Reservations[0].Instances[0].State.Name \
  --output text`
printf '\n\n'
while [[ $INSTANCE_STATE != 'running' ]]
do
  printf ' *'
  sleep 1
  INSTANCE_STATE=`aws ec2 describe-instances \
    --instance-ids $EC2_ID \
    --query Reservations[0].Instances[0].State.Name \
    --output text`
done

aws ec2 create-tags \
  --resources $SPOT_REQ_ID $EC2_ID \
  --tags Key=Name,Value="$EC2_TAG" \
         Key=Owner,Value=`whoami` \
         Key=Creator,Value="$IAM_USER"

if [[ -z $EC2_EIP ]] ; then
  PUBLIC_IP=`aws ec2 describe-instances \
    --instance-ids $EC2_ID \
    --query Reservations[0].Instances[0].PublicIpAddress \
    --output text`
  printf "\n\nNo Elastic IP provided or found.  Using Dynamic IP.\n$PUBLIC_IP\n\n\n"
else
  export EC2_ASSOC=`aws ec2 associate-address \
    --allocation-id $EC2_EIP \
    --instance-id $EC2_ID`

  printf '\nElastic IP Association ID\n'
  echo $EC2_ASSOC
fi

rm raw.txt
printf '\n'
