#!/bin/bash


#____________________________________________________________
#|                                                          | 
#|        	   	 playb				    |
#|                             	                            |
#|              CREATED BY RODRIGO TEIXEIRA                 | 
#|        https://github.com/rodrigotm/play-bash  	    |
#|__________________________________________________________|


# Configs for search ports
START_SEARCH_PORT=9000
# -------------------
END_SEARCH_PORT=9020
# -------------------

# Config save location file contains running ports
RUNNING_PORTS="/tmp/running-ports.txt"

# Config for run Play
APPLICATION_SECRET=""
#--------------------
PATH_CONFIG_FILE="/conf/application-test.conf"
#--------------------
# Important! You need the file build.sbt or other
# file contains into: name := """name-project"""
FILE_BUILD_SBT="build.sbt"
#--------------------
XMX_DEFAULT="768m"
#--------------------
XMS_DEFAULT="768m"

SED=`which sed`
AWK=`which awk`

#Command
C1="$1"

#Option one
O1="$2"

#Option two
O2="$3"

#Option three
O3="$4"

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
	PORT="$1"
	FOLDER="$2"

	if [ -z $PORT ] || [ -z $FOLDER ]
		then
			echo "Ops! You need put port and folder"
			exit
	fi

	kill $PORT &
	sleep 2
	start $PORT $FOLDER
}

#OK function start play
start(){
	echo "Starting..."
	PORT="$1"
	FOLDER="$2"

	if [ -z $APPLICATION_SECRET ]
		then
			echo 'You need put your application secret on /config/play-configs'
			exit
	fi

	if [ -z $PORT  ] || [ -z $FOLDER  ]
		then
			echo 'You need put port number first and after project path. Example: 9001 /opt/git/play-project'
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
	PORT_OR_OPTION="$1"

	echo "Killing..."
	if [ -z $PORT_OR_OPTION ]
		then
			echo "Ops! We don't undestand. For kill all try playb kill -a. For kill one try playb kill 9001"
			exit
	fi

	re='^[0-9]+$'
	if [ -z != $PORT_OR_OPTION ] && [[ $PORT_OR_OPTION =~ $re ]]
		then
			echo "Killing $PORT_OR_OPTION"
			pkill -f "/stage -Dhttp.port=$PORT_OR_OPTION" &
			exit
	fi

	case "$PORT_OR_OPTION" in
	   "-a") echo "Killing all"
			pkill -f "/stage -Dhttp.port=" &
	   ;;

	   *) echo "We don't know this option $PORT_OR_OPTION"
	   exit
	esac
}

#OK function kill play procces
compile(){
	FILE_PROJECT="$1"
	MEM_OPTION="$2"
	MEM_NUMBER="$3"

	echo $FILE_PROJECT
	echo $MEM_OPTION
	echo $MEM_NUMBER

	if [ -z $FILE_PROJECT ]
		then
			echo "Ops! You need put the path project"
			exit
	fi

	if [ -z != $MEM_OPTION ] && [ -z $MEM_NUMBER ]
		then
			echo "Ops! For compile with memory you need put -mem option and number. Example: playb /path/project -mem 256"
			exit
	fi

	if [ -z $MEM_OPTION ] && [ -z != $MEM_NUMBER ]
		then
			echo "Ops! For compile with memory you need put -mem option and number. Example: playb /path/project -mem 256"
			exit
	fi

	if [ -z $MEM_OPTION ] && [ -z $MEM_NUMBER ]
		then
			cd $FILE_PROJECT
			echo "Compiling..."
			sudo ./activator clean stage
			cd
			exit
	fi

	re='^[0-9]+$'
	if [ -z != $MEM_OPTION ] && [ -z != $MEM_NUMBER ] && [[ $MEM_NUMBER =~ $re ]]
		then
			cd $FILE_PROJECT
			echo "Compiling with memory $MEM_NUMBER"
			sudo ./activator clean stage $MEM_OPTION $MEM_NUMBER
			cd
			exit
	fi

	echo "We don't undestand. Maybe you put not a number!"
	exit
}

case "$C1" in
   "snapshot") snapshot $O1
   ;;
   "restart") restart $O1 $O2
   ;;
   "start") start $O1 $O2
   ;;
   "kill") kill $O1
   ;;
   "compile") compile $O1 $O2 $O3
   ;;
   *) echo "What's is your command?"
   exit
esac
