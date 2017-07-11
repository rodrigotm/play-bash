#!/bin/sh
port=9000
portmax=9020
while [ "$port" -le "$portmax" ]; do
    echo "Verifing $port..."
    if grep -q "/stage -Dhttp.port=$port" /tmp/running-ports.txt
        then
             echo "exist $port"
             allPath=`egrep -o "(?/opt.*)(?$port)" running-ports.txt`
             path=`echo $allPath | sed "s/\/target\/universal\/stage \-Dhttp.port=$port//g"`
             echo $path
             sudo start-play $port $path &
        else
            #echo "not exist"
        fi
    port=$(( port + 1 ))
done
rm /tmp/running-ports.txt