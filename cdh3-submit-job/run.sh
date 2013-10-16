#!/bin/sh

TEMP=`getopt -o i::j::h --long ip::,job::,help \
     -n 'cdh3-submit-job' -- "$@"`

if [ $? != 0 ] ; then echo "cdh3-submit-job docker container\n" \
		"Takes a Hadoop Job jar and submits it to the specified job tracker\n" \
		"Use docker's -v bind mount option to make the job jar directory available to docker. \n" \
		"Due to manipulation of /etc/hosts must be run with the -privileged option. \n" \
		"Arguments:\n" \
		"-i --ip IP of the jobtracker\n" \
		"-j --job Path to job jar\n" \
		"-h --help Displays this message\n" \
		"Any additional arguments are used for the job jar\n" \
		"" ; >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

while true ; do
	case "$1" in
		-h|--help) echo "cdh3-submit-job docker container\n" \
		"Takes a Hadoop Job jar and submits it to the specified job tracker\n" \
		"Use docker's -v bind mount option to make the job jar directory available to docker. \n" \
		"Due to manipulation of /etc/hosts must be run with the -privileged option. \n" \
		"Arguments:\n" \
		"-i --ip IP of the jobtracker\n" \
		"-j --job Path to job jar\n" \
		"-h --help Displays this message\n" \
		"Any additional arguments are used for the job jar\n" \
		"" ; exit 0 ;;
		-i|--ip) IP=$2; shift 2 ;;
		-j|--job) JOB=$2; shift 2 ;;		
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done
if [ "" = "$IP" ]; then
	echo "No IP specified.";
	exit 1;
fi

if [ "" = "$JOB" ] ; then
	echo "No Job specified.";
	exit 1;
fi

echo "Starting cdh3-submit-job with the following options:"
echo "Jobtracker IP: $IP"
echo "Job path: $JOB"
echo "Job arguments: $@"

cat /etc/hosts > /tmp/hosts
umount /etc/hosts
if [ $? != 0 ] ; then
	echo "Container must be run in privileged mode."
	exit 1;
	fi
cat /tmp/hosts > /etc/hosts
echo "$IP hadoopmaster" >> /etc/hosts

. /etc/default/hadoop-0.20

hadoop jar $JOB $@