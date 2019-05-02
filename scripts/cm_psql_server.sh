#!/bin/bash

set -e
set -x

function postgresql_install {
    sudo bash -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgsqldg.list'
    sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
    sudo apt-get -y update 
    sudo apt-get -y install postgresql-9.5 postgresql-contrib-9.5
    sudo sed -i "/listen_addresses/a\\listen_addresses = '*'" /etc/postgresql/9.5/main/postgresql.conf
    sudo sed -i "/IPv4 local connections/a\\host    all             all             10.0.5.0/24            md5" /etc/postgresql/9.5/main/pg_hba.conf
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
}

function postgresql_restore_database {
    # postgresql_restore_database(dbname)
    if [ -z "$1" ]; then
        echo "postgresql_restore_database() requires database name as the first argument"
        return 1;
    fi

    sudo -i -u postgres psql -f '/tmp/scm_server_db_backup.sql'
}

function update_config {
sudo sh -c "cat <<EOT > /etc/cloudera-scm-server/db.properties
# CM Config
com.cloudera.cmf.db.type=postgresql
com.cloudera.cmf.db.host=localhost:5432
com.cloudera.cmf.db.name=scm
com.cloudera.cmf.db.user=scm
com.cloudera.cmf.db.password=XuILm36XIa
com.cloudera.cmf.db.setupType=EXTERNAL
EOT"
}

postgresql_install
postgresql_restore_database "scm" 
update_config
sudo systemctl restart postgresql
