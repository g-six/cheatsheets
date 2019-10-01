#!/bin/bash
FILTER='Name=tag:'
FILTER=$FILTER$1',Values='$2

echo "#!/bin/bash" > tmp-script.sh
echo "aws ec2 describe-spot-instance-requests \
  --filter '$FILTER' \
  --query 'SpotInstanceRequests[0]'$3" >> tmp-script.sh

sh tmp-script.sh
rm tmp-script.sh
