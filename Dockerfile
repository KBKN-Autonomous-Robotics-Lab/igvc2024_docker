FROM tiryoh/ros-desktop-vnc:noetic

ENV DEBCONF_NOWARNINGS=yes
ENV DEBIAN_FRONTEND noninteractive
ENV ROS_PYTHON_VERSION 3
ENV ROS_DISTRO=noetic
ENV PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.8/site-packages"

SHELL ["/bin/bash", "-c"]

EXPOSE 22 
EXPOSE 10940
EXPOSE 2368/udp
EXPOSE 8308/udp

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

RUN apt-get autoclean -y && \
    apt-get clean all -y && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    dkms \
    openssh-server && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/run/sshd && \
    echo 'root:ubuntu' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd 

COPY ./startup.sh /startup.sh

# ^ It is not recommended to edit above this line. 

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
    python3-pip \
    python3-testresources \
    gedit \
    gimp 

RUN apt-get update && \
    apt-get upgrade -y && \
    mkdir -p /home/ubuntu/catkin_ws/src && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash; cd /home/ubuntu/catkin_ws/src; catkin_init_workspace" && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash; cd /home/ubuntu/catkin_ws; catkin build" && \
    cd /home/ubuntu/catkin_ws/src && \
    git clone https://github.com/KBKN-Autonomous-Robotics-Lab/igvc2024_src.git && \
    rm igvc2024_src/CMakeLists.txt && \
    mv igvc2024_src/* . && \mv igvc2024_src/.git* . && \
    rm -rf igvc2024_src && \
    bash setup.sh && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash" && \
    catkin clean --yes && \
    chown -R $USER:$USER $HOME && \
    echo "source /home/ubuntu/catkin_ws/devel/setup.bash" >> ~/.bashrc && \
    echo "export ROS_WORKSPACE=/home/ubuntu/catkin_ws" >> ~/.bashrc && \
    echo "alias cm='cd ~/catkin_ws;catkin build'" >> ~/.bashrc && \
    echo "alias cs='cd ~/catkin_ws/src'" >> ~/.bashrc && \
    echo "alias cw='cd ~/catkin_ws'" >> ~/.bashrc

RUN apt-get update && \
    apt-get upgrade -y && \
    cd /home/ubuntu && \
    git clone https://github.com/Livox-SDK/Livox-SDK2.git && \
    cd Livox-SDK2 && \
    mkdir build && cd build && \
    cmake .. && make && \
    make install && \
    # Update host IP address
    sed -i "s/192.168.1.5/192.168.3.1/g" /home/ubuntu/Livox-SDK2/samples/livox_lidar_quick_start/mid360_config.json

RUN apt-get update && \
    apt-get upgrade -y && \
    mkdir -p /home/ubuntu/livox_ws/src && \
    cd /home/ubuntu/livox_ws/src && \
    git clone https://github.com/Livox-SDK/livox_ros_driver2.git && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash" && \
    chown -R $USER:$USER $HOME && \
    # Update host IP address
    sed -i "s/192.168.1.5/192.168.3.1/g" /home/ubuntu/livox_ws/src/livox_ros_driver2/config/MID360_config.json && \
    # Update lidar IP address
    sed -i "s/192.168.1.12/192.168.3.201/g" /home/ubuntu/livox_ws/src/livox_ros_driver2/config/MID360_config.json && \
    echo "alias lsl='cd ~/livox_ws/src/livox_ros_driver2'" >> ~/.bashrc && \
    echo "alias lw='cd ~/livox_ws'" >> ~/.bashrc

RUN python3 -m pip install --user --upgrade --no-cache-dir --no-warn-script-location \
    pip \
    pymodbus==2.5.3 && \
    chown -R $USER:$USER $HOME/.local/
