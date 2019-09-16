# GCP Infrastructure for Cloudera Data Hub

### Install Terraform (Ubuntu, for example):

From this project directory, execute the follwing script to install terraform at the version specified in the `tfconfig.tf` file:
```bash
~$ ./scripts/tf_install.sh
```

Or execute the following installation commands:

```bash
export TERRAFORM_VERSION="<< DESIRED_TERRAFORM_VERSION_HERE >>"
export TERRAFORM_INSTALL_DIR="/usr/local/bin"
wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -O /tmp/terraform.zip
sudo mkdir -p $TERRAFORM_INSTALL_DIR
sudo rm -f /usr/local/bin/terraform
sudo unzip /tmp/terraform.zip -d $TERRAFORM_INSTALL_DIR
sudo chmod +x $TERRAFORM_INSTALL_DIR/terraform
rm /tmp/terraform.zip
```

### Set up your Google Cloud Platform access credentials, following instructions here:

https://www.terraform.io/docs/providers/google/index.html

First you need to allow terraform access GCP resources. This can be achieved by Service Accounts with corresponding access keys.
Within the GCP console tool, gcloud, it can be achieved by issuing the following commands (Note: The terraform service account might already be setup if this is not the initial deployment):

```bash
gcloud config set project [PROJECT_ID]
gcloud config set account [you@pythian.com]
cd ~/gcp/projects/projX
gcloud iam service-accounts create terraform
gcloud iam service-accounts keys create gce-terraform-key.json --iam-account=terraform@<your-project-id>.iam.gserviceaccount.com  
```

After service account is created, login to the GCP console, go to "API & Services", and Credentials. Next, click the Create credentials drop-down list, select Service account key. From the "Create service account key" page, select "terraform" from the Service account list, select JSON as the key type and click Create. This will create and download an API key that will be used by the terraform application to create and access GCP resources. Configure the gcloud command-line tool with the downloaded credentials.

### Enable GCP project services required by Terraform
Execute the following script to the GCP project services required by terraform:
```bash
~$ ./scripts/tf_bootstrap_linux.sh
```

### Setup GCS bucket for Terraform remote state

Ensure the terraform service account has read and write access to GCS buckets.
Execute the following script to generate a unique Google Cloud Storage bucket name for storing remote state:
```bash
~$ ./scripts/tf_autogen_remote_state_gcs_bucket_name.sh
# Example output:
# gs://c8389062275c750ca427fcddcb1bb83b608572c5386204e85101-terraform
```

Copy the generated bucket URL and use the gsutil tool to create the GCS bucket:
```bash
~$ gsutil mb gs://c8389062275c750ca427fcddcb1bb83b608572c5386204e85101-terraform
```

Next, copy the bucket name (portion after gs://) and set it as the bucket value in the 'remotestate_${UNIQUE}.tf' file:
```bash
~$ vi remotestate_mydev.tf
terraform {
  backend "gcs" {
    bucket  = "c8389062275c750ca427fcddcb1bb83b608572c5386204e85101-terraform"
    prefix  = "tfstate/cdh-dev-infrastructure"
    project = "my-dev-proj"
  }
}
```

### Terraform variables setup

#### Example terraform.tfvars:
See [terraform_unique.tfvars.example](./terraform_unique.tfvars.example) file

### Run the ssh-agent:
```bash
~$ eval $(ssh-agent)
~$ ssh-add /path/to/your/private/key/file
```

### Initialize Terraform

To initialize the GCS backend, first load the contents of the service account key (json) file into the environment variable GOOGLE_CREDENTIALS. Note: this step assumes you have the linux terminal open and located in the directory with the terraform files.

Example of loading service account key file contents to GOOGLE_CREDENTIALS environment variable:
```bash
tfuser@localhost:~$ export GOOGLE_CREDENTIALS=$(cat ~/gcp/projects/projX/terraform_service_account_key.json)
```

After the GOOGLE_CREDENTIALS environment variable is set, run the `terraform init` command. If asked to upload local state, type "no".
After a few seconds, terraform should display message "Terraform has been successfully initialized!". If failures were encountered, troubleshoot as needed until the issue is resolved.

Terraform automatically pushes state to this location after update, and will pull state locally when a refresh is run after init is complete.

#### Run Terraform:
```bash
~$ export GOOGLE_CREDENTIALS=$(cat ~/gcp/projects/projX/terraform_service_account_key.json)
...
~$ terraform init
...
~$ terraform plan
...
~$ terraform apply
...
```

#### Auto install of CDH package and cluster build is currently disable. To trigger the install. Make sure the terraform run completed without error.
```
1. ssh to bastion server
2. git clone https://github.com/alcher/cloudera-centos terraform-hadoop
3. cd terraform-hadoop && ansible-playbook -i hosts site.yml

Note: Update the group_var variables if needed.
...
