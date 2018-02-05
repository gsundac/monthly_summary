#! /bin/bash
SSH='/usr/bin/ssh'
HOSTS_LIST='/home/dropbox/monthly_summary/tmp/hosts_summary.list'
PSSH="/usr/bin/pssh"
PSSH_OPTIONS=' -O PasswordAuthentication=no -O StrictHostKeyChecking=no -P -t30'
INFILE='/home/dropbox/monthly_summary/tmp/junk'
INPUT=`cat /home/dropbox/monthly_summary/tmp/hosts_summary.list | awk '{print $1}' > $INFILE`
CMD='sh /tmp/getdata.bash'
TMP_FILE='/home/dropbox/monthly_summary/tmp/tmp.file'

> $TMP_FILE
$SSH -q algernon '/home/gregorsc/algernon4gord.sh'| grep -v authordate > $HOSTS_LIST
$PSSH $PSSH_OPTIONS -h $INFILE $CMD | egrep -v  "SUCCESS|FAILURE" | awk -F: '{print $2}' >> $TMP_FILE
cat $TMP_FILE | grep -v '^$' |
#cat /home/dropbox/monthly_summary/tmp/tmp1.file | grep -v '^$' |
while read LINE;
do
HOST=`echo $LINE | awk '{print $3}'`
SDATE=`grep $HOST $HOSTS_LIST | awk '{print $2}'`
#SDATE=`grep $HOSTS_LIST | awk '{print $2}'`
#STRING='$HOST , $SDATE , $LINE'
# if [ -n  "$STRING" ]; then
echo $HOST , $SDATE , $LINE
# fi
done
