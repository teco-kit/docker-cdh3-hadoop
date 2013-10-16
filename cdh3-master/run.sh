#!/bin/sh
TEMP=`getopt -o hs --long help,skipFormat \
     -n 'cdh3-master' -- "$@"`

if [ $? != 0 ] ; then echo "cdh3-master docker container\n" \
		"Starts a namenode and jobtracker\n" \
		"Due to manipulation of /etc/hosts must be run with the -privileged option. \n" \
		"Arguments:\n" \		
		"-h --help Displays this message\n" \
		"-s --skipFormat Do not format the namenode upon startup. Use this when resuming an existing installation.\n" \
		"" ; >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

while true ; do
	case "$1" in
		-h|--help) echo "cdh3-master docker container\n" \
		"Starts a datanode and tasktracker connected to the specified job tracker\n" \
		"Due to manipulation of /etc/hosts must be run with the -privileged option. \n" \
		"Arguments:\n" \
		"-h --help Displays this message\n" \
		"-s --skipFormat Do not format the namenode upon startup. Use this when resuming an existing installation.\n" \
		"" ; exit 0 ;;		
		-s|--skipFormat) SKIPFORMAT=1; shift ; ;;
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done
echo "Starting cdh3-master"

cat /etc/hosts > /tmp/hosts
umount /etc/hosts
if [ $? != 0 ] ; then
	echo "Container must be run in privileged mode."
	exit 1;
	fi

cat /tmp/hosts > /etc/hosts
for i in $( ip -o addr | awk '!/^[0-9]*: ?lo|link\/ether/ {print $4}' ); do echo $(echo $i | cut -d "/" -f 1) " hadoopmaster" >> /etc/hosts ; done;

. /etc/default/hadoop-0.20
if [ SKIPFORMAT != 1 ]; then
	yes 'Y' | sudo -u hdfs hadoop namenode -format
fi
hadoop namenode &
hadoop secondarynamenode &
hadoop jobtracker
