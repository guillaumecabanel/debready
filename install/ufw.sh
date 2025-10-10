#!/bin/bash

set -e

sudo ufw enable
sudo ufw logging on
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow LocalSend only on local IPv4 LANs
sudo ufw allow from 192.168.0.0/16 to any port 53517 proto tcp
sudo ufw allow from 192.168.0.0/16 to any port 53517 proto udp
