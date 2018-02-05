#! /bin/bash
FILE='/home/sundacg/monthly_summary/outputs/hosts.csv'
cat $FILE | grep -v '^$' |
while read LINE;
do
HOST=`echo $LINE | awk -F, '{print $1}'`
SYEAR=`echo $LINE | awk -F, '{print $2}'| awk -F- '{print $1}'`
CYEAR=`echo $LINE | awk -F, '{print $3}'| awk -F- '{print $1}'`
SMONTH=`echo $LINE | awk -F, '{print $2}'| awk -F- '{print $2}'`
CMONTH=`echo $LINE | awk -F, '{print $3}'| awk -F- '{print $2}'`
if [ "$SYEAR" == " " ]; then
echo "$LINE , NA"
else
YAGE=`echo "($CYEAR-$SYEAR)*12" | bc`
MAGE=`echo "$CMONTH-$SMONTH"| bc`
AGE=`echo "$YAGE+$MAGE"| bc`
echo "$LINE , $AGE"
echo
fi
done
