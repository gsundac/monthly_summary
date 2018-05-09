#!/usr/bin/ssh-agent bash
##! /bin/bash
SSH='/usr/bin/ssh'
HOSTS_LIST='/home/sundacg/monthly_summary/tmp/hosts_summary.list'
PSSH="/usr/bin/parallel-ssh"
PSSH_OPTIONS=' -l root -O PasswordAuthentication=no -O StrictHostKeyChecking=no -P -t20'
INFILE='/home/sundacg/monthly_summary/tmp/list'
INFILE_RESOLVEDTMP='/home/sundacg/monthly_summary/tmp/list.resolvedtmp'
INFILE_RESOLVED='/home/sundacg/monthly_summary/tmp/list.resolved'
INPUT=`cat /home/sundacg/monthly_summary/tmp/hosts_summary.list | awk '{print $1}' > $INFILE`
CMD='/home/sundacg/monthly_summary/scripts/getdata4.bash'
TMP_FILE='/home/sundacg/monthly_summary/tmp/tmp.file'
DATEREGEX='....-..-..'

> $TMP_FILE
$SSH -l root -q algernon '/home/gregorsc/algernon4gord.sh'| grep -v authordate > $HOSTS_LIST
cat $HOSTS_LIST | awk '{print $1}' > $INFILE
for i in `cat $INFILE`; do nslookup $i | grep Name|awk '{print $2}'; done > $INFILE_RESOLVEDTMP
sort -u $INFILE_RESOLVEDTMP > $INFILE_RESOLVED
#eval `ssh-agent`
ssh-add /home/sundacg/.ssh/id_zeus_rsa > /dev/null 2>&1
# ssh-add /home/sundacg/.ssh/id_rsa_edrv0000 > /dev/null 2>&1
# $SSH -l root -q algernon '/home/gregorsc/algernon4gord.sh'| grep -v authordate > $HOSTS_LIST
$PSSH $PSSH_OPTIONS -h $INFILE_RESOLVED -I< $CMD | egrep -v  "SUCCESS|FAILURE" | awk -F: '{print $2}' >> $TMP_FILE
cat $TMP_FILE | grep $DATEREGEX |
while read LINE;
do
HOST=`echo $LINE | awk '{print $3}'`
SDATE=`grep -w $HOST $HOSTS_LIST | awk '{print $2}'`
echo $HOST , $SDATE , $LINE
done
