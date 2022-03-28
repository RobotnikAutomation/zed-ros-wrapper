#!/bin/bash

echo "Starting installation..."

echo "Install screen"
sudo apt-get install screen -y
touch ~/.screenrc
echo "termcapinfo xterm* ti@:te@
shell -$SHELL
setenv LD_LIBRARY_PATH `echo $CMAKE_PREFIX_PATH | awk '{split($1, a, ":"); print a[1];}'`"/lib":/opt/ros/melodic/lib:/opt/ros/melodic/lib/x86_64-linux-gnu
zombie kr
verbose on" > ~/.screenrc

echo "Install jetson bringup"
cp bringup.sh ~/bringup.sh
sudo cp jetson-ros.service /etc/systemd/system
sudo systemctl enable jetson-ros.service

grep -q -F "192.168.0.200 robot-time-server" /etc/hosts
if [ $? -ne 0 ]; then
   sudo sh -c 'echo 192.168.0.200 robot-time-server >> /etc/hosts'
fi

echo "Install ntp server"
sudo apt-get install ntpdate

sudo cp ntp/timesyncd.conf /etc/systemd/timesyncd.conf
sudo systemctl stop ntp
sudo systemctl disable ntp
sudo systemctl enable systemd-timesyncd
sudo systemctl start systemd-timesyncd
cp ntp/ntp-seconds.sh ~/ntp-seconds.sh

echo "Installation completed!"
