aws ec2 create-tags \
  --resources $SPOT_REQ_ID $EC2_ID \
  --tags Key=Name,Value="$EC2_TAG" \
         Key=Creator,Value="$EC2_CREATOR"
