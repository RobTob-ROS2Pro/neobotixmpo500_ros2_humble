#!/bin/sh
uid=$(eval "id -u")
gid=$(eval "id -g")

# Mac user:
# uid=1000
# gid=1000

docker build --build-arg UID="$uid" --build-arg GID="$gid" -t neobotix_mmo500_bringup/ros:humble .
echo "Run Container"
xhost + local:root

docker run --name neobotix_mmo500_bringup --privileged -it --group-add=dialout -e DISPLAY=$DISPLAY \
-v /dev:/dev -v /tmp/.X11-unix:/tmp/.X11-unix -v /home/neobotix/.Xauthority:/home/docker/.Xauthority -v $PWD/navigation:/home/docker/ros2_ws/src/neo_mpo_500-2/configs/navigation --net host --rm --ipc host neobotix_mmo500_bringup/ros:humble
