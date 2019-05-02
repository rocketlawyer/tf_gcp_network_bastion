#!/bin/sh
# NAT
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o `ls /sys/class/net | grep e` -j MASQUERADE
mkdir ansible
sudo apt install python-pip -y 
sudo pip install cm-api
sudo pip install --upgrade pip
