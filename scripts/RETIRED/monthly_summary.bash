RESULTS='hosts.csv'
RES_PATH='/home/dropbox/monthly_summary/outputs'
SCRIPTS='/home/dropbox/monthly_summary/scripts'
HOSTS_LIST='/home/dropbox/monthly_summary/tmp/hosts_summary.list'
DATE=`date +%Y-%m-%d`
SSH='/usr/bin/ssh'
BODY_FILE='/home/dropbox/monthly_summary/scripts/message_body.txt'
> $RES_PATH/$RESULTS
$SSH -q algernon '/home/gregorsc/algernon4gord.sh'| grep -v authordate > $HOSTS_LIST
$SCRIPTS/filecopy2.bash
$SCRIPTS/run_remote2.bash >> $RES_PATH/$RESULTS
$SCRIPTS/datecalc.bash | grep -v -e '^$' > $RES_PATH/allhosts-$DATE.csv
$SCRIPTS/genstats2.bash > $RES_PATH/summary-$DATE.csv
cat $BODY_FILE | mailx -r "root@edrv0000 (Monthly Server Summary)" -s "Monthly Server Summary" -a $RES_PATH/summary-$DATE.csv unixteam@enbridge.com
