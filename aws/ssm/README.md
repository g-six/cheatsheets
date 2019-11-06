### For EC2 instance backup automation

#### Components
- ../ec2/policies/poli-iam-pass-role.json
- ../ec2/policies/poli-iam-trust-ssm.json
- ../ec2/policies/poli-ec2-image-automation.json
- ./documents/instance-image-backup.yml

#### Steps

1. *Create a policy* to allow `iam:PassRole`
../ec2/policies/poli-iam-pass-role.json
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowIAMPassRole",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*"
        }
    ]
}
```

2. *Create a role* for automation  
  - Role should be of type EC2 and 2 policies that  
    needs to be attached are:  
    - The policy above (1).  
    - `AmazonSSMAutomationRole`.
  
  - Edit Trust Relationship  
  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": [
            "ssm.amazonaws.com",
            "ec2.amazonaws.com"
          ]
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  ```

3. Create SSM maintenance window
Create a maintenance window and attach the  
following SSM automation document:
```
---
description: "Creates a new Amazon Machine Image (AMI) from an Amazon EC2 instance"
schemaVersion: "0.3"
assumeRole: "{{ AutomationAssumeRole }}"
parameters:
  InstanceId:
    type: "String"
    description: "(Required) The ID of the Amazon EC2 instance."
  ImageName:
    type: "String"
    description: "(Required) The name of the resulting image."
  NoReboot:
    type: "Boolean"
    description: "(Optional) Do not reboot the instance before creating the image."
    default: false
  AutomationAssumeRole:
    type: "String"
    description: "(Optional) The ARN of the role that allows Automation to perform\
      \ the actions on your behalf. "
    default: ""
mainSteps:
- name: getImage
  action: aws:executeAwsApi
  onFailure: "Abort"
  inputs:
    Service: ec2
    Api: DescribeImages
    Filters:
    - Name: "name"
      Values:
      - "{{ ImageName }}"
  outputs:
    - Name: AmiId
      Selector: "$.Images[0].ImageId"
      Type: String
- name: ImageExists
  action: aws:branch
  inputs:
    Choices:
    - NextStep: deleteImage
      Variable: "{{getImage.AmiId}}"
      StartsWith: "ami-"
    Default: createImage
- name: deleteImage
  action: "aws:deleteImage"
  onFailure: "Abort"
  inputs:
    ImageId: "{{getImage.AmiId}}"
- name: createImage
  action: "aws:createImage"
  onFailure: "Abort"
  inputs:
    InstanceId: "{{ InstanceId }}"
    ImageName: "{{ ImageName }}"
    NoReboot: "{{ NoReboot }}"
outputs:
- "createImage.ImageId"
- "getImage.AmiId"
```
```
