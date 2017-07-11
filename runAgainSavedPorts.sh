#!/bin/bash
./config/play-configs

PORT=$START_SEARCH_PORT

while [ "$PORT" -le "$END_SEARCH_PORT" ]; do
    echo "Verifing $PORT..."
    if grep -q "/stage -Dhttp.port=$PORT" $RUNNING_PORTS
        then
             echo "$PORT was running"
             ALL_PATH_AND_PORT=`egrep -o "(?/opt.*)(?$PORT)" $RUNNING_PORTS`
             PATH=`echo $ALL_PATH_AND_PORT | sed "s/\/target\/universal\/stage \-Dhttp.port=$PORT//g"`
             echo $PATH
             sudo ./start-play $PORT $PATH &
        else
            echo "$PORT wasn’t running"
    fi
    PORT=$(( PORT + 1 ))
done