# Sentry File Uploader
This tool is intended to update Sentry ProGuard mappings in an environment where CI/CD is unable to reach Sentry directly due to firewall rules or deployment in a private VPC. The Lambda can be run in a private VPC and triggered by S3 PUT or other events.
## Build instructions
```
cd src
docker build -t sentry-file-uploader .
docker run -p 9000:8080 sentry-file-uploader:<tag>
```
## Deployment to AWS Lambda
The following Lambda environment variables are required (or useful):
| Name                        	| Description                                        	| Required? 	|
|-----------------------------	|----------------------------------------------------	|-----------	|
| MAPPING_FILENAME            	| Mapping filename e.g. mapping.txt                  	| true      	|
| SENTRY_AUTH_TOKEN_SECRET    	| Sentry auth token stored in Secrets Manager        	| true      	|
| SENTRY_DISABLE_UPDATE_CHECK 	| true (prevents runtime error)                      	| false     	|
| SENTRY_LOG_LEVEL            	| warn (info logs auth token!)                       	| false     	|
| SENTRY_ORG                  	| Your Sentry org name                               	| true      	|
| SENTRY_PROJECT              	| Your Sentry project                                	| true      	|
| SENTRY_URL                  	| Your Sentry org URL                                	| true      	|
| UUID_FILENAME               	| Text file containing *only* the corresponding UUID 	| true      	|

Execute the following from a bash shell (or similar generated from your ECR repo) with a valid AWS authentication token set:
```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS account ID>.dkr.ecr.<AWS region>.amazonaws.com

ECRTAG=$(date +"%Y-%m-%d-%H-%M-%S")

docker tag sentry-file-uploader:latest <AWS account ID>.dkr.ecr.<AWS region>.amazonaws.com/sentry-file-uploader:$ECRTAG

docker push <AWS account ID>.dkr.ecr.<AWS region>.amazonaws.com/sentry-file-uploader:$ECRTAG
```

The Lambda can then be updated to use the new image tag via aws-cli or the console.

## Manual updates
Follow these instructions if there is a need for a manual update of Sentry ProGuard mappings.

Requirements:
- SENTRY_AUTH_TOKEN set in your environment
- Download `mapping.txt` from the S3 bucket to `./test`
- Download `sentryproguarduuid.txt` from the S3 bucket to `./test`
- Connect to AWS VPN (assuming your Sentry instance is deployed in a private VPC)
```
cd test
export SENTRY_AUTH_TOKEN=<your Sentry auth token>
./upload.sh
```
