Create website bucket
```
aws s3 mb \
  s3://<fulldomain> \
  [--profile <profile>]

aws s3 website \
  s3://<fulldomain> \
  [--profile <profile>] \
  --index-document index.html \
  --error-document error.html
```

Upload to website bucket
```
aws s3 sync \
  --acl public-read \
  --sse --delete \
  <src> <bucket>
```
