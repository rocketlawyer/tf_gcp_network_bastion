#!/bin/bash

CDH_SERVER_PRIVATE_IP=$1

sudo setenforce 0 || /bin/true

echo $CDH_SERVER_PRIVATE_IP > /tmp/test
#sudo apt-get install -y cloudera-manager-daemons cloudera-manager-agent
#sudo sed -i 's/server_host=localhost/server_host='"$CDH_SERVER_PRIVATE_IP"'/' /etc/cloudera-scm-agent/config.ini && sudo systemctl start cloudera-scm-agent

