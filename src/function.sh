# Bash handler for syncing S3 files and uploading to Sentry
function handler () {

  # Get the data
  EVENT_DATA=$1

  # Constants
  MAPPING_FILE_TMP="/tmp/$MAPPING_FILENAME"
  UUID_FILE_TMP="/tmp/$UUID_FILENAME"

  # Log the event to stderr
  echo "$EVENT_DATA" 1>&2;

  # Get bucket name
  S3_BUCKET=$(echo "$EVENT_DATA" | jq -r '.Records[0].s3.bucket.name')
  echo "S3 bucket: '$S3_BUCKET'" 1>&2;

  # Get object name
  S3_OBJECT=$(echo "$EVENT_DATA" | jq -r '.Records[0].s3.object.key')
  echo "S3 object: '$S3_OBJECT'" 1>&2;
  echo "Mapping filename: '$MAPPING_FILENAME'" 1>&2;

  # Verify object updated is the mapping file
  if [ "$S3_OBJECT" == "$MAPPING_FILENAME" ]
  then
    # Download mapping file and UUID file
    aws s3 sync s3://$S3_BUCKET/$MAPPING_FILENAME $MAPPING_FILE_TMP
    aws s3 sync s3://$S3_BUCKET/$UUID_FILENAME $UUID_FILE_TMP
    echo "Downloaded mapping and UUID files" 1>&2;

    # Read UUID from file
    UUID=`cat $UUID_FILE_TMP`
    echo "UUID: '$UUID'" 1>&2;

    # Get Sentry auth token from secrets manager
    SENTRY_AUTH_TOKEN=$(aws secretsmanager get-secret-value --secret-id $SENTRY_AUTH_TOKEN_SECRET)

    # Pass mapping file and UUID to sentry-cli
    RESPONSE=$(sentry-cli --auth-token $SENTRY_AUTH_TOKEN upload-proguard --uuid $UUID $MAPPING_FILE_TMP)
  fi

  # Echo Sentry response to Lambda service
  echo $RESPONSE
}