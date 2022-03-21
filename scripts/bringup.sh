#!/bin/bash

export ROBOT_HOSTNAME=192.168.0.200
export JETSON_HOSTNAME=192.168.0.50
export JETSON_WORKSPACE=~/catkin_ws

export ROS_MASTER_URI=http://$ROBOT_HOSTNAME:11311
export ROS_IP=$JETSON_HOSTNAME
# export ROS_HOSTNAME=$HOSTNAME

source /opt/ros/melodic/setup.bash
source $JETSON_WORKSPACE/devel/setup.bash

echo ""
echo -e "ROS_MASTER_URI\t= http://$ROBOT_HOSTNAME:11311"
echo -e "ROS_IP\t= $JETSON_HOSTNAME" 
echo -e "WORKSPACE\t= $JETSON_WORKSPACE/devel/setup.bash"
echo ""

killall screen
sleep 2;
screen -S zed -d -m roslaunch zed_wrapper zed.launch --wait;
