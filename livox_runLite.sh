docker run \
    -e HOME=/home/ubuntu \
    -e SHELL=/bin/bash \
    --shm-size=512m \
    --privileged -it \
    --net=host \
    --entrypoint '/startup.sh'\
    igvc2024/livox
    
    #-e RESOLUTION=1920x1080 \
