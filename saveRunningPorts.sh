#!/bin/bash
source ./config/play-configs

PORT=$START_SEARCH_PORT

rm $RUNNING_PORTS
while [ "$PORT" -le "$END_SEARCH_PORT" ]; do
    echo "Writing $PORT..."
    ps ax | grep port=$PORT >> $RUNNING_PORTS
    PORT=$(( port + 1 ))
done