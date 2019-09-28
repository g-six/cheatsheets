#!/bin/bash
AWS_ID=`aws sts get-caller-identity \
  --profile $AWS_PROFILE \
  --query Account \
  --output text`
IAM_USER=`aws sts get-caller-identity \
  --profile $AWS_PROFILE \
  --query UserId \
  --output text`

echo '{
  "ImageId": "'$AMI_ID'",
  "InstanceType": "'$INSTANCE_TYPE'",
  "KeyName": "'$EC2_KEY'",
  "IamInstanceProfile": { "Arn": "arn:aws:iam::'$AWS_ID':instance-profile/instance-role" },
  "SecurityGroups": ["'$SECGROUP'"],
  "UserData": "'$BASE64_DATA'"
}' > ./launch-specs.json

export SPOT_PRICE=`aws ec2 describe-spot-price-history \
  --profile nerubia \
  --region ap-southeast-1 \
  --instance-types $INSTANCE_TYPE \
  --product-descriptions "Linux/UNIX" \
  --no-paginate \
  --output text \
  --query SpotPriceHistory[0].SpotPrice`

export SPOT_REQ_ID=`aws ec2 request-spot-instances \
  --profile $AWS_PROFILE \
  --spot-price $SPOT_PRICE \
  --instance-count 1 \
  --region ap-southeast-1 \
  --instance-interruption-behavior stop \
  --type persistent \
  --query SpotInstanceRequests[0].SpotInstanceRequestId \
  --no-paginate \
  --output text \
  --launch-specification file://launch-specs.json`

echo 'Spot Request ID: '$SPOT_REQ_ID
sleep 5

export EC2_ID=`aws ec2 describe-spot-instance-requests \
  --profile $AWS_PROFILE \
  --region ap-southeast-1 \
  --no-paginate \
  --output text \
  --query SpotInstanceRequests[*].InstanceId \
  --spot-instance-request-ids $SPOT_REQ_ID`

echo 'Instance ID: '$EC2_ID

aws ec2 create-tags \
  --profile $AWS_PROFILE \
  --region ap-southeast-1 \
  --resources $SPOT_REQ_ID $EC2_ID \
  --tags Key=Name,Value=$IAM_USER
