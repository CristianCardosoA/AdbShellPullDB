#!/bin/bash
#title           :extractDB.sh
#description     :This script will EXTRACT database from installed apk's
#author		 :ccardoso
#date            :20170804
#version         :1.0   
#usage		 :./extractDB.sh
#notes           :Install Adb, remember to put the correct execution permission "chmod +x extractDB.sh"
#==============================================================================/

#colors
RED='\x1B[0;31m'
GREEN='\x1B[0;32m'
NC='\x1B[0m' # No Color

today=$(date +%v)
today=$(echo ${today//[[:blank:]]/})
div=======================================

PROGRAM=""
DEFAULT=NO
##INSERT A DEFAULT
APP_ID='com.ccardoso.mx'

#_read_options(){

	for i in "$@"
	do
		case $i in
    			-p=*|--program=*)
    				PROGRAM="${i#*=}"
    			;;
			-a=*|--appId=*)
                                APP_ID="${i#*=}"
                        ;;
    			--default)
    				DEFAULT=YES
    			;;
    			*)
            			# unknown option
    			;;
		esac
	done

#}


echo "===================================================================="
echo "Start extracting app: $introducedApp" 
echo "===================================================================="
echo "IMPORTANT: Go to your mobile device and press BACK UP MY DATA button without"
echo "===================================================================="
adb backup -noapk $APP_ID
if  [ ! -e "backup.ab" ]; then
	echo -e "${RED} Unable to get database from: $APP_ID ${NC}"
else
	dd if=backup.ab bs=1 skip=24 | python -c "import zlib,sys;sys.stdout.write(zlib.decompress(sys.stdin.read()))" > backup.tar
	tar -xf backup.tar
	echo "Extracting database"
	if  [ ! -e "./apps/com.jjkeller.kmb/db/kmb" ]; then
		echo -e "${RED} Unable to get database from: $APP_ID ${NC}"
	else
		mv ./apps/com.jjkeller.kmb/db/kmb databaseKMB_$today.db
        	rm -rf ./app*
        	rm back*
        	echo -e "${GREEN} Database extracted: databaseKMB_$today.db ${NC}"
        	if [ ! -z "$PROGRAM" ]; then
                	echo -e "${GREEN} Trying to open database program ${NC}"
                	open -a "/Applications/DB Browser for SQLite.app" databaseKMB_$today.db
        	fi
	fi
fi
