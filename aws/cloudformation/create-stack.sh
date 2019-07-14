aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://$CFN.yml --profile pat --capabilities CAPABILITY_IAM
