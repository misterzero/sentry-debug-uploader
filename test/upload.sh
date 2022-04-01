# This script can be run to manually upload ProGuard mappings 
# to Sentry. Requires sentry-cli in PATH.
# See https://docs.sentry.io/product/cli/installation/
SENTRY_URL=https://sentry.thecommonsproject.org/
SENTRY_ORG=thecommonsproject
SENTRY_PROJECT=commonhealth-android-prod
SENTRY_LOG_LEVEL=info
UUID_FROM_S3=`cat sentryproguarduuid.txt`

sentry-cli --auth-token $SENTRY_AUTH_TOKEN upload-proguard --uuid $UUID_FROM_S3 mapping.txt
