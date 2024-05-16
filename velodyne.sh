while true
do
    sudo ifconfig enx207bd23333fa 192.168.3.1
    sudo route add -host 192.168.3.11 gw 192.168.3.1 enx207bd2333fa
    sudo route add -host 192.168.3.201 gw 192.168.3.1 enx207bd2333fa

    sleep 2
done
