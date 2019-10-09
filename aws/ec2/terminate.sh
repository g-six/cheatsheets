if [[ -z $1 ]] ; then
  exit 1
fi
EC2_ID=$1
aws ec2 terminate-instances --instance-ids $EC2_ID
