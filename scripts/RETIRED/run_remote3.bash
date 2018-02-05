#! /bin/bash
SSH='/usr/bin/ssh'
HOSTS_LIST='/home/dropbox/monthly_summary/tmp/hosts_summary.list'
PSSH="/usr/bin/pssh"
PSSH_OPTIONS=' -O PasswordAuthentication=no -O StrictHostKeyChecking=no -P -t30'
# PSSH_OPTIONS=' --inline-stdout -O PasswordAuthentication=no -O StrictHostKeyChecking=no -t10'
INFILE='/home/dropbox/monthly_summary/tmp/junk'
INPUT=`cat /home/dropbox/monthly_summary/tmp/hosts_summary.list | awk '{print $1}' > $INFILE`
CMD='sh /tmp/getdata.bash'
TMP_FILE='/home/dropbox/monthly_summary/tmp/tmp.file'

> $TMP_FILE
$SSH -q algernon '/home/gregorsc/algernon4gord.sh'| grep -v authordate > $HOSTS_LIST
$PSSH $PSSH_OPTIONS -h $INFILE $CMD | egrep -v  "SUCCESS|FAILURE" | awk -F: '{print $2}' >> $TMP_FILE
cat $HOSTS_LIST | grep -v '^$' |
while read LINE;
do
HOST=`echo $LINE | awk '{print $1}'`
SDATE=`echo $LINE | awk '{print $2}'`
STRING=`grep $HOST $TMP_FILE `
if [ -n "$STRING" ]; then
	echo $HOST , $SDATE , $STRING
fi
done
