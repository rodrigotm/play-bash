#!/bin/bash
./config/play-configs

PORT="$1"
PATH="$2"
if [ -z $APLICATION_SECRET ]
	then
		echo 'Do you need put your application secret on /config/play-configs'
		exit
fi

if [ -z $PORT  ] || [ -z $PATH  ]
	then
		echo 'Do you need put port number first and after project path. Example: 9001 /opt/git/play-project'
	else
		cd $PATH
			FILE_PROJECT=`sed -n '/name/{p;q;}' $FILE_BUILD_SBT | awk -F "\"\"\"" '{$0=$2}2'`

    		$PATH/target/universal/stage/bin/$FILE_PROJECT -Dhttp.port=$PORT  -J-Xmx$XMX_DEFAULT -J-Xms$XMS_DEFAULT -Dapplication.secret=$APLICATION_SECRET -Dconfig.file=${PATH}${PATH_CONFIG_FILE} &
			echo 'Starting Play on the port $PORT and path $PATH'
		cd
fi