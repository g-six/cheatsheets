## Request spot instances

Please update accordingly.  
Take note of the **Spot Instance Request ID** as you would need it for checking of the request
status or to cancel request.  
Replace `$DEVBOX_ROLE_ARN` with your AWS account's role used for devboxes.  
Should look something like `arn:aws:iam::YOU_AWS_ACCT_ID:instance-profile/devbox-role`

Also replace the following accordingly (example given):

1. AMI_ID: `ami-0f79d8d28b7a81c1f`

2. EC2_KEY: `nonprod-shared-sg`

```bash
aws ec2 request-spot-instances \
--profile $AWS_PROFILE \
--spot-price 0.031 \
--instance-count 1 \
--region ap-southeast-1 \
--instance-interruption-behavior stop \
--type persistent \
--launch-specification \
    "{ \
        \"ImageId\":\"$AMI_ID\", \
        \"InstanceType\":\"t3a.large\", \
        \"IamInstanceProfile\":\"role-devbox\", \
        \"KeyName\":\"$EC2_KEY\", \
        \"IamInstanceProfile\": {\"Arn\": \"$DEVBOX_ROLE_ARN\"}, \
        \"SecurityGroups\": [\"secgroup-devbox\"]
    }"
```

## See status of request

Please update accordingly.  
Please take note of the **instance id** as you would need it to terminate.  
Replace `$SPOT_REQ_ID` with your Spot Request ID

```bash
aws ec2 describe-spot-instance-requests \
  --profile $AWS_PROFILE \
  --region ap-southeast-1 \
  --spot-instance-request-ids $SPOT_REQ_ID
```

## [IMPORTANT!!!] Tag your instance and spot requests

Replace `$EC2_ID` with your EC2 Instance ID.

```bash
aws ec2 create-tags \
  --profile $AWS_PROFILE \
  --region ap-southeast-1 \
  --resources $SPOT_REQ_ID $EC2_ID \
  --tags Key=devbox,Value=true \
         Key=Name,Value=devbox-<iam_username>

```

## Cancel request

```bash
aws ec2 cancel-spot-instance-requests \
  --profile c$AWS_PROFILEandid \
  --region ap-southeast-1 \
  --spot-instance-request-ids $SPOT_REQ_ID
```

## Terminate spot instances

```bash
aws ec2 terminate-instances \
  --profile $AWS_PROFILE \
  --region ap-southeast-1 \
  --instance-ids $EC2_ID
```

## Extras

### Add Route53 record

Get the hosted zone id. Take note of the ID prefixed by `/hostedzone/`

```bash
aws route53 list-hosted-zones-by-name \
  --profile $AWS_PROFILE \
  --dns-name npcand.com \
  --query HostedZones[*].[Id,Name]
```

Get the instance public ip.

```bash
aws ec2 describe-instances \
  --profile $AWS_PROFILE \
  --region ap-southeast-1 \
  --instance-ids $EC2_ID
```

Create a file that contains the DNS record by matching the subdomain with the IP Address.

```json
{
  "Comment": "Add DNS record for EC2",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "devbox-g6",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "IP.AD.DR.ESS"
          }
        ]
      }
    }
  ]
}
```

Then run the following command (replace `$ROUTE53_ZONE` with your Route53 Zone ID):

```bash
aws route53 change-resource-record-sets \
  --profile $AWS_PROFILE \
  --change-batch file://add-record-set.json \
  --hosted-zone-id $ROUTE53_ZONE
```

**_Links:_**

- [add-record-set.json](./add-record-set.json)

### Retrieve list of active spot requests

```bash
aws ec2 describe-spot-instance-requests \
  --profile $AWS_PROFILE \
  --region ap-southeast-1 \
  --filters Name=state,Values=active
```

#### Without the noise

```bash
aws ec2 describe-spot-instance-requests \
  --profile $AWS_PROFILE \
  --region ap-southeast-1 \
  --filters Name=state,Values=active \
  --output json \
  --query SpotInstanceRequests[*].[InstanceId,SpotInstanceRequestId,SpotPrice,Tags]
```

## Happy coding, you're welcome!

### Spin up containers

SSH into your EC2 instance.

Using docker-compose via created dc alias, do the following in order.

#### Head over to kastle as a starting point

```bash
cd ~/d/kastle
```

#### Redis and postgres

```bash
dc up -d redis postgres
```

#### Restore data / add sample data

DB migration as of 20190531 applies below, so you no longer need to run flyway,  
unless you really want to have a clean slate!

```bash
cd ~/d/kastle/db-dump-restore
sh restore.sh
```

#### Kastle & Skywalk

```bash
cd ~/d/kastle
dc up -d kastle skywalk
```

#### Nginx

```bash
cd ~/d/kastle
dc up -d nginx
```
