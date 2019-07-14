aws ec2 request-spot-instances \
--profile $AWS_PROFILE \
--spot-price 0.035 \
--instance-count 1 \
--region ap-southeast-1 \
--instance-interruption-behavior stop \
--type persistent \
--launch-specification \
    "{ \
        \"ImageId\":\"$AMI_ID\", \
        \"InstanceType\":\"t3a.large\", \
        \"KeyName\":\"$EC2_KEY\", \
        \"IamInstanceProfile\": {\"Arn\": \"$DEVBOX_ROLE_ARN\"}, \
        \"SecurityGroups\": [\"secgroup-web\"]
    }"
