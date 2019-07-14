aws ec2 describe-spot-instance-requests \
  --profile $AWS_PROFILE \
  --region ap-southeast-1 \
  --spot-instance-request-ids $SPOT_REQ_ID