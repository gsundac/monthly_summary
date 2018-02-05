#! /bin/bash
SSH='/usr/bin/ssh'
HOSTS_LIST='/home/dropbox/monthly_summary/tmp/hosts_summary.list'
PSCP="/usr/bin/pscp.pssh"
PSCP_OPTIONS=' -O PasswordAuthentication=no -O StrictHostKeyChecking=no -t10 '
INFILE='/home/dropbox/monthly_summary/tmp/junk'
INPUT=`cat /home/dropbox/monthly_summary/tmp/hosts_summary.list | awk '{print $1}' > $INFILE`
SOURCE_FILE='/home/dropbox/monthly_summary/scripts/getdata.bash'
DEST_FILE='/tmp/getdata.bash'
DATE=`date +%Y-%m-%d_%T`
ERROR_LOG="/home/dropbox/monthly_summary/logs/pscp.errors.$DATE"

$SSH -q algernon '/home/gregorsc/algernon4gord.sh'| grep -v authordate > $HOSTS_LIST
$PSCP $PSCP_OPTIONS -h $INFILE $SOURCE_FILE $DEST_FILE | grep FAILURE > $ERROR_LOG
