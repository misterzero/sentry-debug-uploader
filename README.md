# Sentry File Uploader
## Build/test instructions
```
cd src
docker build -t sentry-file-uploader .
docker run -p 9000:8080 sentry-file-uploader:latest
```
In another command window, run:
```
cd test
curl -XPOST \
"http://localhost:9000/2015-03-31/functions/function/invocations" \
-d "@test-event.json"
```

## Deployment to AWS Lambda
```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 748273271431.dkr.ecr.us-east-1.amazonaws.com

docker tag sentry-file-uploader:latest 748273271431.dkr.ecr.us-east-1.amazonaws.com/sentry-file-uploader:latest

docker push 748273271431.dkr.ecr.us-east-1.amazonaws.com/sentry-file-uploader:latest
```

## Manual updates
Follow these instructions if there is a need for a manual update of Sentry ProGuard mappings.

Requirements:
- SENTRY_AUTH_TOKEN set in your environment
- Download `mapping.txt` from the S3 bucket to `./test`
- Download `sentryproguarduuid.txt` from the S3 bucket to `./test`
- Connect to AWS VPN (assuming your Sentry instance is deployed in a private VPC)
```
cd test
export SENTRY_AUTH_TOKEN=my_sentry_auth_token_xyz
./upload.sh
```
