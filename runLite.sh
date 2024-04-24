docker run \
    -p 6080:80 \
    -p 2222:22 \
    -p 10940:10940 \
    -p 2368:2368/udp \
    -p 8308:8308/udp \
    -e HOME=/home/ubuntu \
    -e SHELL=/bin/bash \
    --shm-size=512m \
    --entrypoint '/startup.sh'\
    tsukuba2023
    
    #-e RESOLUTION=1920x1080 \
