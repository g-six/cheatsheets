aws ec2 create-tags \
  --profile $AWS_PROFILE \
  --region ap-southeast-1 \
  --resources $SPOT_REQ_ID $EC2_ID \
  --tags Key=devbox,Value=true \
         Key=Name,Value="$DEVBOX"
