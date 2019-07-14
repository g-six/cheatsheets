# Getting started
Install `aws cli` (just do a search on www for: How to install aws cli).

Ask your AWS account owner / administrator for your aws credentials and account alias then set your AWS CLI:

```bash
aws configure --profile <your aws account alias>

# Enter your AccessKeyId when prompted
# Enter your SecretAccessKey when prompted
# Enter your region: ap-southeast-1
# Enter your output format as either:
json
# OR
table
```

Unless explicitly instructed, your region should be `ap-southeast-1` (Singapore).
