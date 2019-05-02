#!/bin/bash
# This script checked on CM5.13.3

# Properties
source source_var.sh

# Start Trial
curl -X POST -u "admin:admin" -i $BASE/cm/trial/begin

# Setup Hosts
## Arrange host_list
host_list=""
for i in $TARGET
do
  host_list=$host_list'"'$i'"',
done
host_list=${host_list/%?/}

## Install agent and Assign hosts to deployment
curl -X POST -u "admin:admin" -i \
  -H "content-type:application/json" \
  -d '{ "hostNames": ['$host_list'],
       "userName" : "root",
       "password" : "'$ROOT_PASS'"}'  \
$BASE/cm/commands/hostInstall

## wait for finish installation
echo "Waiting for setup nodes"
while [ 1 ]
do
  target_size=$(expr 1 + `echo $TARGET | grep -o " " | wc -l`)
  installed_hosts=`curl -sS -X GET -u "admin:admin" -i $BASE/hosts | grep '"hostname" :' | wc -l`
  test $target_size -eq $installed_hosts && break
  echo -e "setuped:" $installed_hosts"/"$target_size"\c"
  echo -e "\r\c"
  sleep 10
done

# Setting MGMT
## Create mgmt service
curl -X PUT -u "admin:admin" -i \
  -H "content-type:application/json" \
  -d '{ "name": "mgmt" }'  \
$BASE/cm/service

## Assign and Configure Roles
curl -X PUT -u "admin:admin" -i $BASE/cm/service/autoAssignRoles
curl -X PUT -u "admin:admin" -i $BASE/cm/service/autoConfigure

## Setting Report Manager DB
### Report Manager password
rman_pass=`ssh -o StrictHostKeyChecking=no -l root $CMNODE grep com.cloudera.cmf.REPORTSMANAGER.db.password /etc/cloudera-scm-server/db.mgmt.properties | cut -d= -f2`
### Configuration
curl -X PUT -u "admin:admin" -i \
  -H "content-type:application/json" \
  -d '{ "items": [{"name": "headlamp_database_host",     "value": "'$CMNODE':7432"},
                  {"name": "headlamp_database_name",     "value": "rman"},
                  {"name": "headlamp_database_password", "value": "'$rman_pass'"},
                  {"name": "headlamp_database_user",     "value": "rman"},
                  {"name": "headlamp_database_type",     "value": "postgresql"}
      ]}'  \
$BASE/cm/service/roleConfigGroups/mgmt-REPORTSMANAGER-BASE/config

## Delete Navigator Entry
curl -X DELETE -u "admin:admin" -i \
$BASE/cm/service/roles/`curl -sS -X GET -u "admin:admin" -i $BASE/cm/service/roles | grep -B1 '"type" : "NAVIGATORMETASERVER"' | grep name | cut -d'"' -f4`

curl -X DELETE -u "admin:admin" -i \
$BASE/cm/service/roles/`curl -sS -X GET -u "admin:admin" -i $BASE/cm/service/roles | grep -B1 '"type" : "NAVIGATOR"' | grep name | cut -d'"' -f4`

# Startup
curl -X POST -u "admin:admin" -i $BASE/cm/service/commands/start
