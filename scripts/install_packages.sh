#!/bin/bash

sudo apt-get clean all

sudo setenforce 0 || /bin/true

# FUSE Install
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
sudo echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-get update
sudo apt-get -y install gcsfuse google-cloud-sdk

# CM Repo
wget 'https://archive.cloudera.com/cm5/ubuntu/xenial/amd64/cm/archive.key' -O /tmp/cm-archive.key
sudo apt-key add /tmp/cm-archive.key
wget 'https://archive.cloudera.com/cm5/ubuntu/xenial/amd64/cm/cloudera.list' -O /tmp/cm-cloudera.list
sed -i 's/xenial-cm5/xenial-cm5.13.3/g' /tmp/cm-cloudera.list
sudo cp /tmp/cm-cloudera.list /etc/apt/sources.list.d/cloudera-cm.list

# CDH Repo
wget 'https://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/archive.key' -O /tmp/cdh-archive.key
sudo apt-key add /tmp/cdh-archive.key
wget 'https://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/cloudera.list' -O /tmp/cdh-cloudera.list
sed -i 's/xenial-cdh5/xenial-cdh5.13.3/g' /tmp/cdh-cloudera.list
sudo cp /tmp/cdh-cloudera.list /etc/apt/sources.list.d/cloudera-cdh.list
sudo apt-get update

# Install java
sudo apt-get -y install oracle-j2sdk1.7

# Install Python
sudo apt-get -y install python
