aws cloudformation update-stack \
    --profile $AWS_PROFILE \
    --template-body file://rolling.yml \
    --capabilities CAPABILITY_IAM \
    --stack-name $STACK_NAME \
    --parameters \
        ParameterKey=ApiVhost,ParameterValue=$VIRTUAL_HOST \
        ParameterKey=Branch,ParameterValue=$BRANCH \
        ParameterKey=ECRApiUri,ParameterValue=$ECR_API \
        ParameterKey=ECRDoengineUri,ParameterValue=$ECR_DOENGINE \
        ParameterKey=ECRInterfaceUri,ParameterValue=$ECR_LLI \
        ParameterKey=EnvBucket,ParameterValue=$S3_BUCKET \
        ParameterKey=EC2Key,ParameterValue=$EC2_KEY \
        ParameterKey=IAMInstanceProfile,ParameterValue=$INSTANCE_PROFILE \
        ParameterKey=Notifications,ParameterValue=$NOTIFY \
        ParameterKey=StackVersion,ParameterValue=1 \
        ParameterKey=Subnets,ParameterValue=$SUBNET_1 \
        ParameterKey=Subnets,ParameterValue=$SUBNET_2 \
        ParameterKey=VPC,ParameterValue=$VPC
