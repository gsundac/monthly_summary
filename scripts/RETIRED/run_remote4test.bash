#!/usr/bin/ssh-agent bash
##! /bin/bash

## 
## USED TO TEST MONTHLYSUMMARY.  TO USE, CREATE A LIST OF PROBLEMATIC HOSTS, UPDATE INFILE VARIABLE 
## AND LET RIP

SSH='/usr/bin/ssh'
HOSTS_LIST='/home/dropbox/monthly_summary/tmp/hosts_summary.list'
PSSH="/usr/bin/pssh"
PSSH_OPTIONS=' -O PasswordAuthentication=no -O StrictHostKeyChecking=no -P -t20'
INFILE='/home/dropbox/monthly_summary/tmp/list'
INPUT=`cat /home/dropbox/monthly_summary/tmp/hosts_summary.list | awk '{print $1}' > $INFILE`
CMD='/home/dropbox/monthly_summary/scripts/getdata4.bash'
TMP_FILE='/home/dropbox/monthly_summary/tmp/debugtmp.file'
DATEREGEX='....-..-..'

> $TMP_FILE
#eval `ssh-agent`
ssh-add /root/.ssh/id_zeus_rsa > /dev/null 2>&1
$SSH -q algernon '/home/gregorsc/algernon4gord.sh'| grep -v authordate > $HOSTS_LIST
$PSSH $PSSH_OPTIONS -h $INFILE -I< $CMD | egrep -v  "SUCCESS|FAILURE" | awk -F: '{print $2}' | $TMP_FILE
cat $TMP_FILE | grep $DATEREGEX |
while read LINE;
do
HOST=`echo $LINE | awk '{print $3}'`
SDATE=`grep $HOST $HOSTS_LIST | awk '{print $2}'`
echo $HOST , $SDATE , $LINE
done
