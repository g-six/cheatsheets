## Pre-requisites
### Create your cli-input.json for the create-project command.
- To get the `vpcId` required:  
  ```bash
  aws ec2 describe-vpcs --profile <your IAM profile>
  ```
- To get the `subnets` available:  
  ```bash
  aws ec2 describe-subnets --filters "Name=vpc-id,Values=<vpcId from the step above>" --profile <your IAM profile>
  ```
- To get the `securityGroupIds` available:  
  ```bash
  aws ec2 describe-security-groups --filters "Name=vpc-id,Values=<vpcId from the first step above>" --profile <your IAM profile>
  ```

Be sure also create `buildspec.yaml`  

## Next steps
1. `buildspec.yaml` needs to be uploaded to S3 bucket that is accessible
2. Role should have EC2 all access
3. Using the CLI, execute command to create the codebuild project:  
  ```bash
  aws codebuild create-project --cli-input-json file://cli-input.json --profile <aws-profile-stored-in-your-machine>
  ```
4. Using the CLI, execute command to start build:  
  ```bash
  aws codebuild start-build --project-name <name specified in your cli-input.json> --profile <your IAM profile>
  ```

#### Important
a. If there are properties in your config file that is blank or not used, there will be instances where you'd get an error and your wouldn't understand.  
b. The ARN (role) used must have EC2:* access allowed.  
c. You must delete your codebuild project if there were errors in building pertaining to your ROLE (b)
  ```bash
  aws codebuild delete-project --name <name specified in your cli-input.json> --profile <your IAM profile>
  ```
