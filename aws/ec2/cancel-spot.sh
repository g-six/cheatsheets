if [[ -z $1 ]] ; then
  exit 1
fi
SPOT_REQ_ID=$1
aws ec2 cancel-spot-instance-requests \
  --spot-instance-request-ids $SPOT_REQ_ID
