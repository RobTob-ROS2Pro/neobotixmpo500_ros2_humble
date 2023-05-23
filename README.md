# neobotixmpo500_ros2_humble

This is a ROS2 humble based package to use the Neobotix MMO500 platform.

## How to use?

remote the neobotix via SSH

Build and run the container with
```bash
cd neobotixmpo500_ros2_humble
source start_docker.sh
```

### Control the robot with the logitech controller

In the container run
```bash
ros2 launch neo_mpo_500-2 bringup.launch.py
```

### Autonomous Navigation

You need to have a client-pc with this docker container in the same network.

On the **robot-pc** open another shell in the container

```bash
docker exec -it neobotix_mmo500_bringup bash
```
and start the navigation in that shell
```bash
ros2 launch neo_mpo_500-2 navigation.launch.py
```

On the **client-pc** run in the container
```bash
ros2 launch neo_mpo_500-2 rviz.launch.py
```
You should see the robot and the map loaded in. Now give a pose estimation on where the robot is currently on the real map. If the robot localized itself you can give goal poses.

### Mapping

Run the normal bringup and also run:

```bash
# ros2 run cartographer_ros occupancy_grid_node -resolution 0.05 -publish_period_sec 1.0

ros2 run cartographer_ros cartographer_occupancy_grid_node

```
and
```bash
# ros2 run cartographer_ros cartographer_node -configuration_directory src/neo_mpo_500-2/configs/navigation/mapping -configuration_basename revo_lds1.lua

ros2 run cartographer_ros cartographer_node -configuration_directory install/neo_mpo_500-2/share/neo_mpo_500-2/configs/ -configuration_basename test.lua
```
To see your mapping progress run
```bash
ros2 launch neo_mpo_500-2 rviz.launch.py
```
Before saving the map change directory in
```bash
cd ~/ros2_ws/src/neo_mpo_500-2/configs/navigation/maps
```
Then run
```bash
ros2 run nav2_map_server map_saver_cli -f map_name
``` 

### Behavior Tree

1. Run autonomous navigation as described above.

2. Start the docker for navigation action bridge from foxy to galactic

    ```bash
    cd petra_nav_bridge
    source start_docker.sh
    # if not started per default:
    ros2 launch petra_nav_bridge nav_bridge.launch.py
    ```

3. Start the coordinator with predefined behavior

    ```bash
    cd neobotix_coordinator
    source start_docker.sh
    # if not started per default:
    ros2 launch neobotix_coordinator test.launch.py
    ```

## ToDo
- [ ] Evaluate if automatically starting the navigation is more usefull
