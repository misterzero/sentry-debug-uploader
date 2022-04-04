# This script can be run to manually upload ProGuard mappings to Sentry.
# This can be useful if you're in a hurry or wish to verify your project
# settings. Requires sentry-cli in PATH as well as mapping.txt and
# corresponding UUID in sentryproguarduuid.txt present in this directory.
# See https://docs.sentry.io/product/cli/installation/
SENTRY_URL=<your Sentry org URL>
SENTRY_ORG=<your Sentry org ID>
SENTRY_PROJECT=<your Sentry project ID>
SENTRY_AUTH_TOKEN=<your Sentry auth token>
SENTRY_LOG_LEVEL=info
# Replace sentryproguarduuid.txt with your UUID filename if differnt
UUID_FROM_S3=`cat sentryproguarduuid.txt`

sentry-cli --auth-token $SENTRY_AUTH_TOKEN upload-proguard --uuid $UUID_FROM_S3 mapping.txt
