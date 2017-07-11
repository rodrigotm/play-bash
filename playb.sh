#!/bin/bash
source ./config/play-configs

#____________________________________________________________
#|                                                          | 
#|        					playb							|
#|                             	                            |
#|          CREATED BY RODRIGO TEIXEIRA              		| 
#|                  https://github.com/rodrigotm/play-bash  |
#|__________________________________________________________|

#Command
C1="$1"

#Option one
O1="$2"

#Option two
O2="$3"

#OK function save snapshot
saveSnapShot(){
	PORT=$START_SEARCH_PORT

	rm $RUNNING_PORTS
	while [ "$PORT" -le "$END_SEARCH_PORT" ]; do
	    echo "Searching $PORT..."
	    ps ax | grep port=$PORT >> $RUNNING_PORTS
	    PORT=$(( PORT + 1 ))
	done
}

#OK function restore snapshot
restoreSnapShot() {
	PORT=$START_SEARCH_PORT

	while [ "$PORT" -le "$END_SEARCH_PORT" ]; do
	    echo "Verifing $PORT..."
	    if grep -q "/stage -Dhttp.port=$PORT" $RUNNING_PORTS
	        then
	            echo "$PORT was running"
	            ALL_PATH_AND_PORT=`egrep -o "(?/opt.*)(?$PORT)" $RUNNING_PORTS`
	            FOLDER=`echo $ALL_PATH_AND_PORT | sed "s/\/target\/universal\/stage \-Dhttp.port=$PORT//g"`
	            echo $FOLDER
	            start $PORT $FOLDER &
	    fi
	    PORT=$(( PORT + 1 ))
	done
}

#OK function snapshot
snapshot(){
	OPTION="$1"

	case "$OPTION" in
	   "-s") echo "Saving snapshot..."
			saveSnapShot
	   ;;
	   "-r") echo "Restoring snapshot..."
			restoreSnapShot
	   ;;
	   *) echo "We don't know this option $OPTION"
	   exit
	esac
}

#OK function restart play
restart(){
	echo "Restarting..."
}


#OK function start play
start(){
	echo "Starting..."
	PORT="$1"
	FOLDER="$2"

	if [ -z $APPLICATION_SECRET ]
		then
			echo 'Do you need put your application secret on /config/play-configs'
			exit
	fi

	if [ -z $PORT  ] || [ -z $FOLDER  ]
		then
			echo 'Do you need put port number first and after project path. Example: 9001 /opt/git/play-project'
		else

			cd $FOLDER
				FILE_PROJECT=`$SED -n '/name/{p;q;}' $FILE_BUILD_SBT | $AWK -F "\"\"\"" '{$0=$2}2'`

				rm $FOLDER/target/universal/stage/RUNNING_PID

	    		$FOLDER/target/universal/stage/bin/$FILE_PROJECT -Dhttp.port=$PORT  -J-Xmx$XMX_DEFAULT -J-Xms$XMS_DEFAULT -Dapplication.secret=$APPLICATION_SECRET -Dconfig.file=${FOLDER}${PATH_CONFIG_FILE} &
				echo "Starting Play on the port $PORT and path $FOLDER"
			cd
	fi
}

#OK function kill play procces
kill(){
	PORT="$1"
	OPTION="$2"
	
	echo "Killing..."
	if [ -z != $PORT ] && [ -z != $OPTION ]
		then
			echo "Ops! We don't undestand. For kill all try playb kill -a. For kill one try playb kill 9001"
			exit
	fi

	re='^[0-9]+$'
	if [ -z != $PORT ] && [[ $PORT =~ $re ]]
		then
			echo "Killing $PORT"
			pkill -f "/stage -Dhttp.port=$PORT" &
			exit
	fi

	case "$OPTION" in
	   "-a") echo "Killing all"
			pkill -f "/stage -Dhttp.port=" &
	   ;;

	   *) echo "We don't know this option $OPTION"
	   exit
	esac
}

case "$C1" in
   "snapshot") snapshot $O1
   ;;
   "restart") restart 
   ;;
   "start") start $O1 $O2
   ;;
   "kill") kill $O1 $O2
   ;;
   *) echo "What's is your command?"
   exit
esac