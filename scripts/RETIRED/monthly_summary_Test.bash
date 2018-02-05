RESULTS='hosts.csv'
RES_PATH='/home/dropbox/monthly_summary/outputs'
SCRIPTS='/home/dropbox/monthly_summary/scripts'
HOSTS_LIST='/home/dropbox/monthly_summary/tmp/hosts_summary.list'
DATE=`date +%Y-%m-%d`
SSH='/usr/bin/ssh'
BODY_FILE='/home/dropbox/monthly_summary/scripts/message_body.txt'
> $RES_PATH/$RESULTS
$SCRIPTS/run_remote4.bash >> $RES_PATH/$RESULTS
$SCRIPTS/datecalc.bash | grep -v -e '^$' > $RES_PATH/allhosts-$DATE.csv
$SCRIPTS/genstats4.bash > $RES_PATH/summary-$DATE.csv
echo "Hostname, In Date, Report Date, DNS, Location, Uptime, Authentication, OS, Kernel, Hardware, Application Support Group, IP Address, Serial Number, Procs, Cores, CPU Type,  Mem, Age (M), Users" > $RES_PATH/allhosts.csv
cat $RES_PATH/allhosts-$DATE.csv >> $RES_PATH/allhosts.csv
#cat $BODY_FILE | mailx -r "root@edrv0000 (Monthly Server Summary)" -s "Monthly Server Summary" -a $RES_PATH/summary-$DATE.csv unixteam@enbridge.com kyle.bereska@enbridge.com
