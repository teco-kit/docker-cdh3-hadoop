#!/bin/sh
TEMP=`getopt -o i::h --long ip::,help \
     -n 'cdh3-slave' -- "$@"`

if [ $? != 0 ] ; then echo "cdh3-slave docker container\n" \
		"Starts a datanode and tasktracker connected to the specified job tracker\n" \
		"Due to manipulation of /etc/hosts must be run with the -privileged option. \n" \
		"Arguments:\n" \
		"-i --ip IP of the jobtracker and namenode\n" \
		"-h --help Displays this message\n" \
		"" ; >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

while true ; do
	case "$1" in
		-h|--help) echo "cdh3-slave docker container\n" \
		"Starts a datanode and tasktracker connected to the specified job tracker\n" \
		"Due to manipulation of /etc/hosts must be run with the -privileged option. \n" \
		"Arguments:\n" \
		"-i --ip IP of the jobtracker and namenode\n" \
		"-h --help Displays this message\n" \
		"" ; exit 0 ;;
		-i|--ip) IP=$2; shift 2 ;;		
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done

if [ "" = "$IP" ]; then
	echo "No IP specified.";
	exit 1;
fi

echo "Starting cdh3-slave with the following options:"
echo "Jobtracker IP: $IP"

cat /etc/hosts > /tmp/hosts
umount /etc/hosts
if [ $? != 0 ] ; then
	echo "Container must be run in privileged mode."
	exit 1;
	fi
cat /tmp/hosts > /etc/hosts
echo "$IP hadoopmaster" >> /etc/hosts

. /etc/default/hadoop-0.20
hadoop datanode &
hadoop tasktracker