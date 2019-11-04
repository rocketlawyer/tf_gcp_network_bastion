
#!/bin/bash

##################################################
# Enable project services required for terraform #
##################################################

echo "**********************************************************************************************"
echo "$(date) => [INFO]  => Requires Google Cloud SDK version 179.0.0 or later"
echo "**********************************************************************************************"

echo "$(date) => [INFO]  => Enable Google Cloud APIs (cloudapis.googleapis.com)"
gcloud services enable cloudapis.googleapis.com

echo "$(date) => [INFO]  => Enable Google Service Management API (servicemanagement.googleapis.com)"
gcloud services enable servicemanagement.googleapis.com

echo "$(date) => [INFO]  => Enable Google Service Usage API (serviceusage.googleapis.com)"
gcloud services enable serviceusage.googleapis.com

echo "$(date) => [INFO]  => Enable Google Cloud Storage JSON API (storage-api.googleapis.com)"
gcloud services enable storage-api.googleapis.com

echo "$(date) => [INFO]  => Enable Google Cloud Storage (storage-component.googleapis.com)"
gcloud services enable storage-component.googleapis.com

echo "$(date) => [INFO]  => Enable Google Identity and Access Management (IAM) API (iam.googleapis.com)"
gcloud services enable iam.googleapis.com

echo "$(date) => [INFO]  => Enable Google Cloud Resource Manager API (cloudresourcemanager.googleapis.com)"
gcloud services enable cloudresourcemanager.googleapis.com

echo "$(date) => [INFO]  => Enable Google Compute Engine API (compute.googleapis.com)"
gcloud services enable compute.googleapis.com

echo "$(date) => [INFO]  => Enable Google Cloud Deployment Manager V2 API (deploymentmanager.googleapis.com)"
gcloud services enable deploymentmanager.googleapis.com
