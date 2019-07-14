## Quick way to get AWS Account number
```bash
aws sts get-caller-identity --output text --query 'Account' --profile ___
```