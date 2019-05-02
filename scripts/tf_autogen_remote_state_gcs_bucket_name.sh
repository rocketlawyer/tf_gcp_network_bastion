#!/bin/bash

##################################################
# Generate a Google Cloud Storage bucket URL     #
# for terraform remote state storage             #
##################################################

# Example:
# gs://76016c016c526f0f33b493416082b1f028c4503e4c14f935d048-terraform
#
# See Google Cloud Storage Bucket and Object Naming Guidelines
# https://cloud.google.com/storage/docs/naming

# Generate a new random bucket name
BUCKET_NAME_MAX_LENGTH=63
BUCKET_NAME=`echo -n $(uuidgen | sha256sum | awk '{print $1}')-terraform | tail -c $BUCKET_NAME_MAX_LENGTH`
BUCKET_URL=gs://$BUCKET_NAME

# Display the bucket URL
echo $BUCKET_URL
