PRINTMANIFEST="/opt/ignite/bin/print_manifest -s"
MACHINFO="/usr/contrib/bin/machinfo"
CSTM="/usr/sbin/cstm"
DMIDECODE="/usr/sbin/dmidecode"
UNAME=`uname`
HOSTNAME=`hostname| awk -F"." '{print $1}'` 
UPTIME=`uptime | awk '{print $3}'|sed s/,//g`
IPADDR=`nslookup \`hostname\` 10.65.64.159 | grep Address: | grep -v \# | grep -v 10.65.64.159 | awk '{print $2}'`
NWLOC=`echo $IPADDR | awk -F. '{print $1 $2 $3}'`
DATE=`date +%Y-%m-%d`
##Removing last login info as it sucks.  It is not formatted in a standard way, so it just screws things up.
##LSTLGN=`last | egrep -v "scan|sysdscvr|reboot|wtmp|gorodeto|sundacg|mcgillr1|kureshij|chuid|carpend4|bodnarcr|root|svcpwdvt|sysmonit"| head -1|awk '{print $1" " $4" "$5" "$6}'`
##LSTLGN_WHO=`echo $LSTLGN | awk '{print $1}'`
##LSTLGN_WHEN=`echo $LSTLGN | awk '{print $3 $4}'`
COMP_ROLE="NA"   #Pre-populating this so it gets filled in regardless of what happens in the centrify section
# This is the worst joke of code yet....
# Trying to determine if things are updated via patching, so the Linux Kernels are determined by comparing the output of uname -r to the list of current
# kernels below.  You have to update the list of current kernels on a periodic basis now...that sucks.
# Solaris 10 is done in a similar way.  We compare the SUNWcsr package time stamp.
 
##Q1_2016_CURRENT_KERNELS="2.6.18-409.el5|2.6.32-573.22.1.el6.x86_64|2.6.32-400.26.3.el5uek|2.6.39-400.277.1.el5uek|2.6.18-409.el5|on10-patch20160217152310|2.6.32-400.26.3.el5uek|2.6.39-400.215.9.el5uek| 2.6.39-400.277.1.el6uek.x86_64|B.11.31.1303.390|B.11.31.1603.421a|B.11.23.1012.086a|B.11.11.0912.483"

RHEL6=2.6.32-642.4.2.el6.x86_64
RHEL5_32=2.6.18-412.el5PAE
RHEL5_64=2.6.18-412.el5
OEL6UEK=2.6.39-400.284.2.el6uek
OEL5UEK=2.6.39-400.286.3.el5uek
OEL6=2.6.32-642.4.2.el6
OEL5=2.6.18-412
HPUX1131="B.11.31.1609.424"
HPUX1123=Depricated
HPUX1111=Depricated
SOLARIS10="on10-patch20130301071732"
SOLARIS8=Depricated
SOLARIS11=TBD
CURRENT_KERNELS="$RHEL6|$RHEL5_32|$RHEL6_64|$OEL6UEK|$OEL5UEK|$OEL6|$OEL5|$HPUX1131|$HPUX1123|$HPUX1111|$SOLARIS10|$SOLARIS8|$SOLARIS11"

case "$NWLOC" in

	1065[0-9][0-9]) LOCATION=MLP;;
	1065[0-9][0-9][0-9]) LOCATION=MLP;;
	20734126) LOCATION=MLP-DMZ;;
	10722[0-9][0-9]) LOCATION=MLP-PL;;
	10721[5-7][0-9]) LOCATION=MLP-PL-EXA;;
    	107013[2-3]) LOCATION=MLP-SCADA
    	;;
    	10666[0-9]) LOCATION=SEO;;
    	1066[1-3][2-4][0-9]) LOCATION=SEO-PL;;
    	106615[2-4]) LOCATION=SEO-PL-EXA;;
    	106694) LOCATION=SEO-PL-VBLK;;
    	107013[6-9]) LOCATION=SEO-SCADA;;
    	1611412) LOCATION=SEO-DMZ
	;;
    	1070[0-32]) LOCATION=ENB2-SCADA
	;;
	1070128) LOCATION=REMOTE-PLC-SCADALab
	;;
	107064)	LOCATION=REMOTE-EDMTerm-SCADA
	;;
	10170[0-9]) LOCATION=VPC
	;;
	10170[0-9][0-9]) LOCATION=VPC
	;;
	10179[0-9]) LOCATION=THOROLD
	;;
	10179[0-9][0-9]) LOCATION=THOROLD
	;;
    	*)	LOCATION=REMOTE
    	;;
    esac

## Figure out auth mechanism and count root equivs if auth is centrify
if [ -f "/etc/nsswitch.conf" ]; then
	sed -n '/^passwd/p' /etc/nsswitch.conf | grep -i files > /dev/null 2>&1
              if [ $? = 0 ]; then
              AUTH=Files
              fi
	sed -n '/^passwd/p' /etc/nsswitch.conf | grep -i nis > /dev/null 2>&1
              if [ $? = 0 ]; then
              AUTH=NIS
		fi
	sed -n '/^passwd/p' /etc/nsswitch.conf | grep -i Centrify > /dev/null 2>&1
              if [ $? = 0 ]; then
	      COMP_ROLE="Not Defined"
              AUTH=Centrify
	      COMP_ROLET=`dzinfo -Cf | egrep 'Computer Role' | awk -F: '{print $NF}' | sort -u`
              COMP_ROLE=`echo $COMP_ROLET`
	      fi
else
	AUTH=Files
fi

if [ "$AUTH" = "Centrify" ]; then
      USERLIST=`adquery user  | awk -F: '{print $1}'`;
      USERS=`echo $USERLIST | wc -w`
      else
      USERS="NA"
      fi



case "$UNAME" in

 HP-UX) MODEL=`model`;

	SERIAL=`getconf MACHINE_SERIAL`;
	if [ -z "$SERIAL" ]; then

		if [ -e "$MACHINFO" ]; then
			SERIAL=`$MACHINFO |  grep "Machine serial number" | awk -F: '{print $2}'`
		else
			SERIAL=`$PRINTMANIFEST | grep "Serial number" | awk -F\: '{print $2}'`
		fi
	fi

	PROCS=`/sbin/ioscan -k | grep processor | wc -l`;
	CPROC="0";
	MEM=`echo "selclass qualifier memory;info;wait;infolog"| $CSTM | grep " System Total (MB)" | awk '{print $(NF)}'`;
	if [ -n "$MEM" ]; then
		MEMG=`echo "$MEM/1024" | bc`
		else
		MEMG=0
	fi
#        KERNEL_LEVEL=`/usr/sbin/swlist -a revision -a mod_date  -l product SW-DIST | grep SW-DIST`;
#        KERNEL_LEVEL=`/usr/sbin/swlist -a revision -l product SW-DIST | grep SW-DIST`;
        KERNEL_LEVEL=`/usr/sbin/swlist -l bundle | grep -Ei 'GOLD|QPK'|grep -i base | awk '{print $2}'`;
        CURRENT=`echo $KERNEL_LEVEL | egrep "$CURRENT_KERNELS"`
        if [ -n "$CURRENT" ]; then
                UP2DATE="Y"
        else
                UP2DATE="N"
        fi

	VERSION=`uname`;
##	NUNAME=`uname -r`;
	NUNAME=$KERNEL_LEVEL;
	PROC_TYPE=`uname -m` ;
	APPGUESS=`cat /etc/snmpd.conf | grep ^contact: | awk -F= '{print $3}'`;;

##echo      "$DATE , $HOSTNAME , $LOCATION , $UPTIME , $AUTH , $VERSION , $NUNAME , $MODEL , $APPGUESS , $IPADDR , $SERIAL , $PROCS , $CPROC , $PROC_TYPE , $MEMG , $USERS , $UP2DATE , $COMP_ROLE "


 Linux)	MODEL=`$DMIDECODE | grep -m 1 "Product Name" | awk -F\: '{print $2}'` ; 
	SERIAL=`$DMIDECODE | grep -m 1 "Serial Number" | awk -F\: '{print $2}'` ; 
   		if [ -f /etc/system-release ]; then
		VERSION=`cat /etc/system-release`
		elif [ -f /etc/enterprise-release ]; then
		VERSION=`cat /etc/enterprise-release`
		elif [ -f /etc/oracle-release ]; then
		VERSION=`cat /etc/oracle-release`
		elif [ -f /etc/redhat-release ]; then
		VERSION=`cat /etc/redhat-release`
		elif [ -f /etc/SuSE-release ]; then
		VERSION=`cat /etc/SuSE-release| grep Linux`
		else
		VERSION="Unspecified Linux"
		fi
#	if [ -f "/usr/sbin/rhn-channel" ]; then
#		CHANNEL=`rhn-channel -b`
#		UPDATE_AVAIL=`yum check-update kernel| grep -i kernel`
#	else
#		CHANNEL='NA'
#		UPDATE='NA'
#	fi
#	if [ -z "$UPDATE_AVAIL" ]; then
#		UP2DATE="Y"
#	else
#		UP2DATE="N"
#	fi
##	echo "$CHANNEL - $UPDATE_AVAIL"
##	echo "$CHANNEL - $UP2DATE"
	KERNEL_LEVEL=`uname -r`;
#	CURRENT=`echo $KERNEL_LEVEL | egrep '$CURRENT_KERNELS'`
	CURRENT=`echo $CURRENT_KERNELS | egrep $KERNEL_LEVEL`
	if [ -n "$CURRENT" ]; then
		UP2DATE="Y"
	else 
		UP2DATE="N"
	fi
	NUNAME=`uname -r`;
	CPROC=`dmidecode -t4 | grep "Core Count" | sort -u | awk '{print $3}'`
	PROCS=`dmidecode -t4 | grep "Socket Designation" | sort -u | wc -l`
	PROC_TYPE=`cat /proc/cpuinfo | grep "model name" | sort -u | awk -F\: '{print $2}'`
	MEM=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`
	MEMG=`echo "$MEM/1000/1024" | bc`
	APPGUESS=`cat /etc/snmp/snmpd.conf | grep ^syscontact | awk -F= '{print $3}'`;;

  SunOS) if [ -c /dev/zconsole ]; then
		MODEL="Non Global Container"
	else 
 		MODEL=`prtdiag | grep ^"System Configuration:" | awk -F: '{print $2}' | sed 's/Oracle Corporation  sun4.//g'| sed 's/Sun Microsystems  sun4.//g'|sed 's/SPARC Enterprise//g'|sed 's/Sun//g'`;
        fi

	if [ -f "/usr/sbin/sneep" ]; then
		SERIAL=`/usr/sbin/sneep | awk '{print $1}'`
	else
		SERIAL="Not Detected"
	fi
	KERNEL_LEVEL=`pkginfo -l SUNWcsr | grep PSTAMP | awk '{print $2}'`
#	CURRENT=`echo $KERNEL_LEVEL | egrep "$CURRENT_KERNELS"`
	CURRENT=`echo $CURRENT_KERNELS | egrep $KERNEL_LEVEL`
	if [ -n "$CURRENT" ]; then
                UP2DATE="Y"
        else
                UP2DATE="N"
        fi
	RUNAME=`uname -r`; 
	VUNAME=`uname -v`;
	
	NUNAME=`echo $VUNAME"("$KERNEL_LEVEL")"`;
	VERSION="$UNAME $RUNAME"
	PROCS=`psrinfo -p`
	CPROC=`psrinfo -pv | grep "virtual processors" | awk '{print $5}'| sort -u| tr '\n' ' ' | grep [0-9]`
	PROC_TYPE=`psrinfo -pv | grep SPARC | awk '{print $1 "@"$(NF-1)$(NF)}' | sed 's/)//g'| sort -u`
	MEM=`prtconf 2> /dev/null | grep "Memory size" | awk '{print $3}'`
	MEMG=`echo "$MEM/1024" | bc`
	APPGUESS=`egrep "OS=UNIX Server Support" /etc/sma/snmp/snmpd.conf | awk -F= '{print $3}'`;;

 *)      printf SOMETHINGELSE;;
esac

echo      "$DATE , $HOSTNAME , $LOCATION , $UPTIME , $AUTH , $VERSION , $NUNAME , $MODEL , $APPGUESS , $IPADDR , $SERIAL , $PROCS , $CPROC , $PROC_TYPE , $MEMG , $USERS , $UP2DATE , $COMP_ROLE "

