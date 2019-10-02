output='--output '$2
query='--query '$1
if [ -z $1 ]
then
  query=""
fi
if [ -z $2 ]
then
  output=""
fi
instances=$(aws ec2 describe-instances \
  --instance-ids $EC2_ID \
  $output $query)
echo $instances | json_pp 
exit 1
for instance in $instances
do
  echo $instance',\n'
done
