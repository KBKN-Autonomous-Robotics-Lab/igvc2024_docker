# igvc2024_docker
This is a project for IGVC2024.

## Setup⚙️
### Build from Dockerfile🛠️
#### TeraTerm💻
~~~
git clone https://github.com/KBKN-Autonomous-Robotics-Lab/igvc2024_docker.git
cd igvc2024_docker
./*_build.sh
./*_runLite.sh
~~~
Put velodyne or livox in *. \
Browse http://{IP_ADDRESS_OF_YOUR_PC}:6080/

#### Container🧰
~~~
cd ~/livox_ws/src/livox_ros_driver2 && ./build.sh ROS1
source ~/livox_ws/devel/setup.sh
cd ~/catkin_ws && catkin build
source ~/.bashrc
~~~
