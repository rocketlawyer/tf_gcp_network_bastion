#!/bin/sh

# Determine the version of terraform to install
TERRAFORM_CONFIG_FILE="tfconfig.tf"
TERRAFORM_VERSION_TO_INSTALL="$(cat $TERRAFORM_CONFIG_FILE | grep 'required_version' | awk '{print $NF}' | tr -d '"')"

# Install terraform
export TERRAFORM_VERSION="$TERRAFORM_VERSION_TO_INSTALL"
export TERRAFORM_INSTALL_DIR="/usr/local/bin"
wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -O /tmp/terraform.zip
sudo mkdir -p $TERRAFORM_INSTALL_DIR
sudo rm -f /usr/local/bin/terraform
sudo unzip /tmp/terraform.zip -d $TERRAFORM_INSTALL_DIR
sudo chmod +x $TERRAFORM_INSTALL_DIR/terraform

# Cleanup
rm /tmp/terraform.zip
