#!/bin/bash

echo "Starting installation..."

echo "Install chrony"
sudo apt-get install -y chrony
sudo cp ntp/chrony.conf /etc/chrony
sudo systemctl daemon-reload
sudo systemctl enable chrony
sudo systemctl stop chrony
sudo systemctl start chrony

echo "Installation completed"


