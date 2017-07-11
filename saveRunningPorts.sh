#!/bin/sh
rm 
port=9000
portmax=9020
while [ "$port" -le "$portmax" ]; do
    echo "Writing $port..."
    ps ax | grep port=$port >> /tmp/running-ports.txt
    port=$(( port + 1 ))
done