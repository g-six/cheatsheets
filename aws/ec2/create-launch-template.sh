aws ec2 create-launch-template \
--profile $AWS_PROFILE \
--launch-template-name tpl-spot \
--launch-template-data \
    "{ \
        \"NetworkInterfaces\": [{\"DeviceIndex\": 0, \"SubnetId\": \"$SUBNET_ID\"}], \
        \"ImageId\":\"$AMI_ID\", \
        \"InstanceType\":\"t3a.large\", \
        \"TagSpecifications\":[{\"ResourceType\":\"instance\",\"Tags\":[{\"Key\":\"Name\",\"Value\":\"$EC2_TAG\"}]}] \
    }"
