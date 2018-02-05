#! /bin/bash
EXCEPTION_FILE='/home/dropbox/monthly_summary/tmp/exceptions'
FILE='/home/dropbox/monthly_summary/outputs/allhosts-2016-12-13.csv'
cat $FILE | grep -v '^$' |
while read LINE;
do
HOST=`echo $LINE | awk -F, '{print $1}'`
EXCEPTION=`grep $HOST $EXCEPTION_FILE`
if [ -z "$EXCEPTION" ]; then
echo "$LINE , N"
else
echo "$LINE , Y"
fi
done
