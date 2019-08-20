#!/bin/bash

# Performance 
# Swappiness to 1
sudo sysctl vm.swappiness=1  # Sets at runtime
sudo bash -c "echo 'vm.swappiness = 1' >> /etc/sysctl.conf"  # Persists after reboot

# Disable Transparent Huge Page Compaction
sudo yum -y install sysfsutils
sudo bash -c "echo never > /sys/kernel/mm/transparent_hugepage/defrag"   # At runtime
sudo bash -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"  # At runtime
sudo bash -c "echo 'echo never > /sys/kernel/mm/transparent_hugepage/defrag' >> /etc/rc.d/rc.local"   # Persists after reboot
sudo bash -c "echo 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' >> /etc/rc.d/rc.local"  # Persists after reboot
sudo chmod +x /etc/rc.d/rc.local  # Activate script

#sudo tee /etc/systemd/system/disable-thp.service > /dev/null <<EOF
#[Unit]
#Description=Disable Transparent Huge Pages (THP)
#
#[Service]
#Type=simple
#ExecStart=/bin/sh -c "echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled && echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag"
#
#[Install]
#WantedBy=multi-user.target
#EOF
#
#sudo systemctl daemon-reload
#sudo systemctl start disable-thp
#sudo systemctl enable disable-thp
