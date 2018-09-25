RESULTSTMP='hoststmp.csv'
RESULTS='hosts.csv'
RES_PATH='/home/sundacg/monthly_summary/outputs'
SCRIPTS='/home/sundacg/monthly_summary/scripts'
HOSTS_LIST='/home/sundacg/monthly_summary/tmp/hosts_summary.list'
DATE=`date +%Y-%m-%d`
SSH='/usr/bin/ssh'
BODY_FILE='/home/sundacg/monthly_summary/scripts/message_body.txt'
> $RES_PATH/$RESULTSTMP
> $RES_PATH/$RESULTS
$SCRIPTS/run_remote4.bash >> $RES_PATH/$RESULTS
# $SCRIPTS/run_remote4.bash >> $RES_PATH/$RESULTSTMP
# sort -u $RES_PATH/$RESULTSTMP >> $RES_PATH/$RESULTS
$SCRIPTS/datecalc.bash | grep -v -e '^$' > $RES_PATH/allhosts-$DATE.csv
$SCRIPTS/genstats4.bash > $RES_PATH/summary-$DATE.csv

/usr/bin/mysql -uroot -pifa6isa9 -h cheddar --local-infile ISS_UNIX_DATA -e "load data local infile '"$RES_PATH/allhosts-$DATE.csv"' into table hist_base_data_2018 fields terminated by ',' lines terminated by '\n'" 

# echo "Hostname, In Date, Report Date, DNS, Location, Uptime, Authentication, OS, Kernel, Hardware, Application Support Group, IP Address, Serial Number, Procs, Cores , CPU_Type , Mem, Users , Up2Date , AD Comp Role , Oracle_Processes , Oracle_Guess , Age (M)" > $RES_PATH/allhosts.csv
# Uncomment the line above if you want to get oracle process report......also have to mod the getdata4.bash script
echo "Hostname, In Date, Report Date, DNS, Location, Uptime, Authentication, OS, Kernel, Hardware, Application Support Group, App Support Fact, Service Fact, SubService Fact, Status Fact, P-Exemption Fact, IP Address, Serial Number, Procs, Cores, CPU_Type, Mem, Users, Up2Date, AD Comp Role, Facts, Puppet, Ora Processes, Ora Guess, Inception, OOB Mgmnt Addr , Age (M)" > $RES_PATH/allhosts.csv
cat $RES_PATH/allhosts-$DATE.csv >> $RES_PATH/allhosts.csv
# cat $BODY_FILE | mailx -r "root@edrv0000 (Monthly Server Summary)" -s "Monthly Server Summary" -a $RES_PATH/summary-$DATE.csv unixteam@enbridge.com kyle.bereska@enbridge.com
