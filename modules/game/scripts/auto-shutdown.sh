#!/bin/bash

# Configuration
PORT=${shutdown_port_on_no_players}
PROTOCOL="${shutdown_protocol_on_no_players}"
WAIT_TIME=600      # 10 minutes in seconds
MONITOR_TIME=300   # 5 minutes in seconds

echo "Monitoring incoming traffic on $PROTOCOL/$PORT on all interfaces..."

while true; do
    # Wait for 10 minutes without checking
    sleep $WAIT_TIME
    
    echo "Checking for incoming traffic on $PROTOCOL/$PORT for up to 5 minutes..."
    # Use tcpdump to detect incoming traffic on all interfaces for up to 5 minutes
    PACKET=$(timeout $MONITOR_TIME tcpdump -i any "dst port $PORT and $PROTOCOL" -c 1 -l)
    
    if [ $? -eq 124 ]; then  # Exit code 124 means timeout
        echo "No incoming traffic received on $PROTOCOL/$PORT in the last 15 minutes. Shutting down the system..."
        sudo shutdown -h now
    else
        echo "Packet detected: $(date) - $PACKET"
    fi

done