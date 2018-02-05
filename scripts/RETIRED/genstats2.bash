#! /bin/bash
RESULTS='hosts.csv'
RES_PATH='/home/dropbox/monthly_summary/outputs'
DATAFILE="$RES_PATH/$RESULTS"

# Total Server Summary
HPUX_TOTAL=`grep HP-UX  $DATAFILE | wc -l`
RHEL_TOTAL=`grep "Red Hat Enterprise Linux" $DATAFILE | wc -l`
ORAC_TOTAL=`egrep "Oracle Linux|Enterprise Linux Enterprise Linux|Oracle VM" $DATAFILE | wc -l`
SUNOS_TOTAL=`grep "SunOS" $DATAFILE | wc -l`
OTHEROS=`egrep -v "^$|SunOS|Red Hat Enterprise Linux|HP-UX|Oracle Linux|Enterprise Linux Enterprise Linux|Oracle VM" $DATAFILE | wc -l`
TOTALOSI=`echo "$HPUX_TOTAL + $RHEL_TOTAL + $SUNOS_TOTAL + $ORAC_TOTAL + $OTHEROS" | bc`

# Virtual Server Summary
VHPUX_TOTAL=`grep HP-UX $DATAFILE | grep "VMWare" | wc -l`
VRHEL_TOTAL=`grep "Red Hat Enterprise Linux" $DATAFILE |  grep "VMware Virtual Platform" | wc -l`
VORAC_TOTAL=`egrep "Oracle| Enterprise Linux Enterprise Linux" $DATAFILE | egrep -v "Red Hat|SunOS" |  egrep "VMware Virtual Platform|HVM domU" | wc -l`
VSUNOS_TOTAL=`grep "SunOS" $DATAFILE | grep NGC | wc -l`
VOTHEROS=`egrep -v "^$|SunOS|Red Hat Enterprise Linux|HP-UX|Enterprise Linux Enterprise" $DATAFILE | grep "VMware Virtual Platform" | wc -l`
VTOTALOSI=`echo "$VHPUX_TOTAL + $VRHEL_TOTAL + $VSUNOS_TOTAL + $VORAC_TOTAL + $VOTHEROS" | bc`

# Phyiscal Server Summary
#PHPUX_TOTAL=`echo "$HPUX_TOTAL-$VHPUX_TOTAL"| bc`
PHPUX_TOTAL=$HPUX_TOTAL
PRHEL_TOTAL=`echo "$RHEL_TOTAL-$VRHEL_TOTAL"| bc`
PORAC_TOTAL=`echo "$ORAC_TOTAL-$VORAC_TOTAL"| bc`
PSUNOS_TOTAL=`echo "$SUNOS_TOTAL-$VSUNOS_TOTAL"| bc`
POTHEROS_TOTAL=`echo "$OTHEROS-$VOTHEROS"| bc`
PTOTALOSI=`echo "$PHPUX_TOTAL + $PRHEL_TOTAL + $PSUNOS_TOTAL + $PORAC_TOTAL + $POTHEROS_TOTAL" | bc`

# Age Summary  - not done
OHPUX_TOTAL=`grep HP-UX $DATAFILE | grep -v "VMware" | awk '{print $(NF)}' | egrep "49|[5-9][0-9]|[1-9][0-9][0-9]" | wc -l`
ORHEL_TOTAL=`grep "Red Hat Enterprise Linux" $DATAFILE | grep -v "VMware" | awk '{print $(NF)}' | egrep "4[8-9]|[5-9][0-9]|[1-9][0-9][0-9]" | wc -l`
OORAC_TOTAL=`grep "Oracle" $DATAFILE | grep -v "VMware" | awk '{print $(NF)}' | egrep "4[8-9]|[5-9][0-9]|[1-9][0-9][0-9]" | wc -l`
OSUNOS_TOTAL=`grep "SunOS" $DATAFILE | grep -v "NGC" | awk '{print $(NF)}' | egrep "4[8-9]|[5-9][0-9]|[1-9][0-9][0-9]" | wc -l`
OOTHEROS=`egrep -v "^$|SunOS|Red Hat Enterprise Linux|HP-UX" $DATAFILE | grep -v "VMware" | awk '{print $(NF)}' |grep -v \- | egrep "4[8-9]|[5-9][0-9]|[1-9][0-9][0-9]" | wc -l`
OTOTALOSI=`echo "$OHPUX_TOTAL + $ORHEL_TOTAL + $OSUNOS_TOTAL + $OOTHEROS" | bc`

# Location Summary - Added VPC and THOR
MLP_TOTAL=`grep MLP $DATAFILE | wc -l`
SEO_TOTAL=`grep SEO $DATAFILE | wc -l`
ENB2_TOTAL=`grep ENB2 $DATAFILE | wc -l`
REMOTE_TOTAL=`egrep "EDMTerm|REMOTE|PLC" $DATAFILE | wc -l`
THOR_TOTAL=`grep THOROLD $DATAFILE | wc -l`
VPC_TOTAL=`grep VPC $DATAFILE | wc -l`
UNDEFINED=`egrep -v "^$|REMOTE|ENB2|SEO|MLP|PLC|EDMTerm" $DATAFILE | wc -l`
TOTALLS=`echo "$MLP_TOTAL + $SEO_TOTAL + $ENB2_TOTAL + $REMOTE_TOTAL + $UNDEFINED" | bc` 

# Virtual Location Summary - Added VPC and THOR
MLP_VTOTAL=`grep MLP $DATAFILE | egrep "VMware Virtual|NGC|HVM domU" | wc -l`
SEO_VTOTAL=`grep SEO $DATAFILE | egrep "VMware Virtual|NGC|HVM domU" | wc -l`
ENB2_VTOTAL=`grep ENB2 $DATAFILE | egrep "VMware Virtual|NGC|HVM domU" | wc -l`
# EPL_VTOTAL=`grep PLC $DATAFILE | egrep "VMware Virtual|NGC|HVM domU" | wc -l`
# EDTERM_PTOTAL=`grep EDMTerminal $DATAFILE | egrep "VMware Virtual|NGC|HVM domU" | wc -l`
REMOTE_VTOTAL=`egrep "EDMTerm|REMOTE|PLC" $DATAFILE | egrep "VMware Virtual|NGC|HVM domU" | wc -l`
THOR_VTOTAL=`grep THOROLD $DATAFILE | egrep "VMware Virtual|NGC|HVM domU" | wc -l`
VPC_VTOTAL=`grep VPC $DATAFILE | egrep "VMware Virtual|NGC|HVM domU" | wc -l`
VTOTALLS=`echo "$MLP_VTOTAL + $SEO_VTOTAL + $ENB2_VTOTAL + $THOR_VTOTAL + $VPC_VTOTAL + $REMOTE_VTOTAL" | bc`

# Physical Location Summary - Added VPC and THOR
MLP_PTOTAL=`grep MLP $DATAFILE | egrep -v "VMware Virtual|NGC|HVM domU" | wc -l`
SEO_PTOTAL=`grep SEO $DATAFILE | egrep -v "VMware Virtual|NGC|HVM domU" | wc -l`
ENB2_PTOTAL=`grep ENB2 $DATAFILE | egrep -v "VMware Virtual|NGC|HVM domU" | wc -l`
EPL_PTOTAL=`grep PLC $DATAFILE | egrep -v "VMware Virtual|NGC|HVM domU" | wc -l`
EDTERM_PTOTAL=`grep EDMTerminal $DATAFILE | egrep -v "VMware Virtual|NGC|HVM domU" | wc -l`
REMOTE_PTOTAL=`egrep "REMOTE|EDMTerm|PLC" $DATAFILE | egrep -v "VMware Virtual|NGC|HVM domU" | wc -l`
VPC_PTOTAL=`grep VPC $DATAFILE | egrep -v "VMware Virtual|NGC|HVM domU" | wc -l`
THOR_PTOTAL=`grep THOROLD $DATAFILE | egrep -v "VMware Virtual|NGC|HVM domU" | wc -l`
PTOTALLS=`echo "$EPL_PTOTAL + $MLP_PTOTAL + $SEO_PTOTAL + $ENB2_PTOTAL + $REMOTE_PTOTAL + $VPC_PTOTAL + $THOR_PTOTAL" | bc`

# Location Detailed Physical Server Inv for Team Report - Added VPC and THOR
MLP_HP_RHEL=`grep MLP $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "ProLiant"| wc -l`
MLP_HP_ORAC=`grep MLP $DATAFILE | egrep "Oracle Linux" | egrep -v VMware | egrep "ProLiant"| wc -l`
MLP_CISCO_RHEL=`grep MLP $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "BASE-|UCSB-|UCSC-"| wc -l`
MLP_CISCO_ORAC=`grep MLP $DATAFILE | egrep "Oracle Linux" | egrep -v VMware | egrep "BASE-|UCSB-|UCSC-"| wc -l`
MLP_HPUX=`grep MLP $DATAFILE | egrep "HP-UX" | wc -l`
MLP_SUN_ORAC=`grep MLP $DATAFILE | egrep "Oracle VM server" | wc -l`
MLP_SOL=`grep MLP $DATAFILE | egrep "SunOS" | grep -v Global | wc -l`
MLP_HP_RHEL_CONSOLE=`grep MLP $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep -i "HP Z8|workstation"| wc -l`
SEO_HP_RHEL=`grep SEO $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "ProLiant"| wc -l`
SEO_HP_ORAC=`grep SEO $DATAFILE | egrep "Oracle Linux" | egrep -v VMware | egrep "ProLiant"| wc -l`
SEO_CISCO_RHEL=`grep SEO $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "BASE-|UCSB-|UCSC-"| wc -l`
SEO_CISCO_ORAC=`grep SEO $DATAFILE | egrep "Oracle Linux" | egrep -v VMware | egrep "BASE-|UCSB-|UCSC-"| wc -l`
SEO_HPUX=`grep SEO $DATAFILE | egrep "HP-UX" | wc -l`
SEO_SUN_ORAC=`grep SEO $DATAFILE | egrep "Oracle VM server" | wc -l`
SEO_SOL=`grep SEO $DATAFILE | egrep "SunOS" | grep -v Global | wc -l`
SEO_HP_RHEL_CONSOLE=`grep SEO $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep -i "HP Z8|workstation"| wc -l`
ENB2_HP_RHEL=`grep ENB2 $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "ProLiant"| wc -l`
ENB2_HP_ORAC=`grep ENB2 $DATAFILE | egrep "Oracle Linux" | egrep -v VMware | egrep "ProLiant"| wc -l`
ENB2_CISCO_RHEL=`grep ENB2 $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "BASE-|UCSB-|UCSC-"| wc -l`
ENB2_CISCO_ORAC=`grep ENB2 $DATAFILE | egrep "Oracle Linux" | egrep -v VMware | egrep "BASE-|UCSB-|UCSC-"| wc -l`
ENB2_HPUX=`grep ENB2 $DATAFILE | egrep "HP-UX" | wc -l`
ENB2_SOL=`grep ENB2 $DATAFILE | egrep "SunOS" | grep -v Global | wc -l`
ENB2_HP_RHEL_CONSOLE=`grep ENB2 $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep -i "HP Z8|workstation"| wc -l`
REMOTE_HP_RHEL=`grep REMOTE $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "ProLiant"| wc -l`
REMOTE_HP_ORAC=`grep REMOTE $DATAFILE | egrep "Oracle Linux" | egrep -v VMware | egrep "ProLiant"| wc -l`
REMOTE_CISCO_RHEL=`grep REMOTE $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "BASE-|UCSB-|UCSC-"| wc -l`
REMOTE_CISCO_ORAC=`grep REMOTE $DATAFILE | egrep "Oracle Linux" | egrep -v VMware | egrep "BASE-|UCSB-|UCSC-"| wc -l`
REMOTE_HPUX=`grep REMOTE $DATAFILE | egrep "HP-UX" | wc -l`
REMOTE_SOL=`grep REMOTE $DATAFILE | egrep "SunOS" | grep -v Global | wc -l`
REMOTE_HP_RHEL_CONSOLE=`grep REMOTE $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep -i "HP Z8|workstation"| wc -l`
THOR_HP_RHEL=`grep THOR $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "ProLiant"| wc -l`
THOR_HP_ORAC=`grep THOR $DATAFILE | egrep "Oracle Linux" | egrep -v VMware | egrep "ProLiant"| wc -l`
THOR_CISCO_RHEL=`grep THOR $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "BASE-|UCSB-|UCSC-"| wc -l`
THOR_CISCO_ORAC=`grep THOR $DATAFILE | egrep "Oracle Linux" | egrep -v VMware | egrep "BASE-|UCSB-|UCSC-"| wc -l`
THOR_DELL_RHEL=`grep VPC $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "PowerEdge"| wc -l`
THOR_DELL_ORAC=`grep VPC $DATAFILE | egrep "Oracle Linux|Enterprise Linux Enterprise Linux Server" | egrep -v VMware | egrep "PowerEdge"| wc -l`
THOR_HPUX=`grep THOR $DATAFILE | egrep "HP-UX" | wc -l`
THOR_SOL=`grep THOR $DATAFILE | egrep "SunOS" | grep -v Global | wc -l`
THOR_HP_RHEL_CONSOLE=`grep THOR $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep -i "HP Z8|workstation"| wc -l`
VPC_HP_RHEL=`grep VPC $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "ProLiant"| wc -l`
VPC_HP_ORAC=`grep VPC $DATAFILE | egrep "Oracle Linux" | egrep -v VMware | egrep "ProLiant"| wc -l`
VPC_CISCO_RHEL=`grep VPC $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "BASE-|UCSB-|UCSC-"| wc -l`
VPC_CISCO_ORAC=`grep VPC $DATAFILE | egrep "Oracle Linux" | egrep -v VMware | egrep "BASE-|UCSB-|UCSC-"| wc -l`
VPC_DELL_RHEL=`grep VPC $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep "PowerEdge"| wc -l`
VPC_DELL_ORAC=`grep VPC $DATAFILE | egrep "Oracle Linux|Enterprise Linux Enterprise Linux Server" | egrep -v VMware | egrep "PowerEdge"| wc -l`
VPC_HPUX=`grep VPC $DATAFILE | egrep "HP-UX" | wc -l`
VPC_SOL=`grep VPC $DATAFILE | egrep "SunOS" | grep -v Global | wc -l`
VPC_HP_RHEL_CONSOLE=`grep VPC $DATAFILE | egrep "Red Hat|RHEL" | egrep -v VMware | egrep -i "HP Z8|workstation" | wc -l`

# OUTPUT TIME
# Added VPC and THOR
echo "===========,============,==========,==========,=========="
echo "PHYSICAL Location Breakdown"
echo "===========,============,==========,==========,=========="
echo "ENB2,HP,RHEL,$ENB2_HP_RHEL"
echo "ENB2,HP,OEL,$ENB2_HP_ORAC"
echo "ENB2,CISCO,RHEL,$ENB2_CISCO_RHEL"
echo "ENB2,CISCO,OEL,$ENB2_CISCO_ORAC"
echo "ENB2,HPUX,11,$ENB2_HPUX"
echo "ENB2,SUN,Solaris8-11,$ENB2_SOL"
echo "FIELD,HP,RHEL,$REMOTE_HP_RHEL"
echo "FIELD,HP,OEL,$REMOTE_HP_ORAC"
echo "FIELD,CISCO,RHEL,$REMOTE_CISCO_RHEL"
echo "FIELD,CISCO,OEL,$REMOTE_CISCO_ORAC"
echo "FIELD,HPUX,11,$REMOTE_HPUX"
echo "FIELD,SUN,Solaris8-11,$REMOTE_SOL"
echo "MLP,HP,RHEL,$MLP_HP_RHEL"
echo "MLP,HP,OEL,$MLP_HP_ORAC"
echo "MLP,CISCO,RHEL,$MLP_CISCO_RHEL"
echo "MLP,CISCO,OEL,$MLP_CISCO_ORAC"
echo "MLP,HPUX,11,$MLP_HPUX"
echo "MLP,SUN,OEL,$MLP_SUN_ORAC"
echo "MLP,SUN,Solaris8-11,$MLP_SOL"
echo "SEO,HP,RHEL,$SEO_HP_RHEL"
echo "SEO,HP,OEL,$SEO_HP_ORAC"
echo "SEO,CISCO,RHEL,$SEO_CISCO_RHEL"
echo "SEO,CISCO,OEL,$SEO_CISCO_ORAC"
echo "SEO,HPUX,11i,$SEO_HPUX"
echo "SEO,SUN,OEL,$SEO_SUN_ORAC"
echo "SEO,SUN,Solaris8-11,$SEO_SOL"
echo "THOR,HP,RHEL,$THOR_HP_RHEL"
echo "THOR,HP,OEL,$THOR_HP_ORAC"
echo "THOR,DELL,RHEL,$THOR_DELL_RHEL"
echo "THOR,DELL,OEL,$THOR_DELL_ORAC"
echo "THOR,CISCO,RHEL,$THOR_CISCO_RHEL"
echo "THOR,CISCO,OEL,$THOR_CISCO_ORAC"
echo "THOR,HPUX,11,$THOR_HPUX"
echo "THOR,SUN,Solaris8-11,$THOR_SOL"
echo "VPC,HP,RHEL,$VPC_HP_RHEL"
echo "VPC,HP,OEL,$VPC_HP_ORAC"
echo "VPC,DELL,RHEL,$VPC_DELL_RHEL"
echo "VPC,DELL,OEL,$VPC_DELL_ORAC"
echo "VPC,CISCO,RHEL,$VPC_CISCO_RHEL"
echo "VPC,CISCO,OEL,$VPC_CISCO_ORAC"
echo "VPC,HPUX,11,$VPC_HPUX"
echo "VPC,SUN,Solaris8-11,$VPC_SOL"
echo
echo "===========,============,==========,==========,=========="
echo "Console Breakdown"
echo "===========,============,==========,==========,=========="
echo "MLP,HP_CONSOLES,RHEL,$MLP_HP_RHEL_CONSOLE"
echo "SEO,HP_CONSOLES,RHEL,$SEO_HP_RHEL_CONSOLE"
echo "ENB2,HP_CONSOLES,RHEL,$ENB2_HP_RHEL_CONSOLE"
echo "REMOTE,HP_CONSOLES,RHEL,$REMOTE_HP_RHEL_CONSOLE"
echo
echo
echo "===========,============,==========,==========,=========="
echo "OS_Summary,Virtual,Physical,Phy>4Yrs,Total"
echo "===========,============,==========,==========,=========="
echo "Total_HPUX,$VHPUX_TOTAL,$PHPUX_TOTAL,$OHPUX_TOTAL,$HPUX_TOTAL"
echo "Total_RedHat,$VRHEL_TOTAL,$PRHEL_TOTAL,$ORHEL_TOTAL,$RHEL_TOTAL"
echo "Total_OEL,$VORAC_TOTAL,$PORAC_TOTAL,$OORAC_TOTAL,$ORAC_TOTAL"
echo "Total_Solaris,$VSUNOS_TOTAL,$PSUNOS_TOTAL,$OSUNOS_TOTAL,$SUNOS_TOTAL"
echo "Total_Other,$VOTHEROS,$POTHEROS_TOTAL,$OOTHEROS,$OTHEROS"
echo "-----------,---------,---------------,---------,---------"
echo "Total_Servers,$VTOTALOSI,$PTOTALOSI,$OTOTALOSI,$TOTALOSI"
echo "===========,============,==========,==========,=========="
echo
echo "===========,============,==========,==========,=========="
echo "LOC_Summary,Virtual,Physical,Total"
echo "===========,============,==========,==========,=========="
echo "MLP_DC,$MLP_VTOTAL,$MLP_PTOTAL,$MLP_TOTAL"
echo "SEO_DC,$SEO_VTOTAL,$SEO_PTOTAL,$SEO_TOTAL"
echo "Enb_Tower,$ENB2_VTOTAL,$ENB2_PTOTAL,$ENB2_TOTAL"
echo "Remote,$REMOTE_VTOTAL,$REMOTE_PTOTAL,$REMOTE_TOTAL"
echo "VPC,$VPC_VTOTAL,$VPC_PTOTAL,$VPC_TOTAL"
echo "Thorhold,$THOR_VTOTAL,$THOR_PTOTAL,$THOR_TOTAL"
echo "-----------,---------,---------------,---------,---------"
echo "Totals,$VTOTALLS,$PTOTALLS,$TOTALLS"
echo "===========,============,==========,==========,=========="
