#!/bin/bash

# yum clean
sudo yum clean all -y

# disable selinux and firewall
sudo setenforce 0 || /bin/true
sudo systemctl disable firewalld 
sudo systemctl stop firewalld

# FUSE Install
sudo tee /etc/yum.repos.d/gcsfuse.repo > /dev/null <<EOF
[gcsfuse]
name=gcsfuse (packages.cloud.google.com)
baseurl=https://packages.cloud.google.com/yum/repos/gcsfuse-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF


sudo rpm --import https://packages.cloud.google.com/yum/doc/yum-key.gpg
sudo rpm --import https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
sudo yum update --assumeno
sudo yum -y install gcsfuse google-cloud-sdk

# Install Python
sudo yum -y install python
