#!/bin/bash
aws iam delete-login-profile --user-name $1 > /dev/null &

sleep 1.5

groups=$(aws iam list-groups-for-user --user-name $1 --query Groups[*].GroupName --output text)

for group in $groups
do
  echo 'Removing '$1' from '$group' user group.'
  aws iam remove-user-from-group --user-name $1 --group-name $group
done

inline_policies=$(aws iam list-user-policies --user-name $1 --query PolicyNames[*] --output text)

for policy in $inline_policies
do
  echo 'Delete inline '$policy' from '$1
  aws iam delete-user-policy --user-name $1 --policy-name $policy
done


policies=$(aws iam list-attached-user-policies --user-name $1 --query AttachedPolicies[*].PolicyArn --output text)

for policy in $policies
do
  echo 'Detach '$policy
  aws iam detach-user-policy --user-name $1 --policy-arn $policy
done

access_keys=$(aws iam list-access-keys --user-name michael --query AccessKeyMetadata[*].AccessKeyId --output text)
for key in $access_keys
do
  echo 'Delete access '$key
  aws iam delete-access-key --user-name $1 --access-key-id $key
done

aws iam delete-user --user-name $1
