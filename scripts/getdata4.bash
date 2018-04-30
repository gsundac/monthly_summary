#! /bin/sh
### To test this out....
###  pssh -O PasswordAuthentication=no -O StrictHostKeyChecking=no -P -t20 -H vprv0017 -I< /home/sundacg/monthly_summary/scripts/getdata4.bash
###  Another hint...initialize your variables before you try to echo them out, or HPUX has issues.
## Initializing all these...
DATE=HOSTNAME=LOCATION=UPTIME=AUTH=VERSION=NUNAME=MODEL=APPGUESS=ENBAPPSUPPORT=ENBSERVICE=ENBSUBSERVICE=ENBSTATUS=ENBPTCHEXMPTN=IPADDR=SERIAL=PROCS=CPROC=PROC_TYPE=MEMG=USERS=UP2DATE=COMP_ROLE=FACTS=PUPPET=ORA_PROCS=ORAGUESS=INCEPTION=" "
PRINTMANIFEST="/opt/ignite/bin/print_manifest -s"
MACHINFO="/usr/contrib/bin/machinfo"
CSTM="/usr/sbin/cstm"
DMIDECODE="/usr/sbin/dmidecode"
UNAME=`uname`
RUNAME=`uname -r`
HOSTNAME=`hostname| awk -F"." '{print $1}'` 
UPTIMEA=`uptime | awk -F" " '{print $3}'|sed s/,//g`
RESOLVER=`cat /etc/resolv.conf | grep nameserver | head -1 | awk '{print $2}'`
#IPADDR=`nslookup \`hostname\` | grep Address: | grep -v \# | grep -v $RESOLVER | awk '{print $2}'`
IPADDR=`nslookup $HOSTNAME | grep Address: | grep -v \# | grep -v $RESOLVER | awk '{print $2}'`
# IPADDR=`nslookup \`hostname\` $RESOLVER | grep Address: | grep -v \# | grep -v $RESOLVER | awk '{print $2}'`
NWLOC=`echo $IPADDR | awk -F. '{print $1 $2 $3}'`
DATE=`date +%Y-%m-%d`
ORA_PROCS=`ps -ef | grep -i oracle | grep -v grep|wc -l `

# For Oracle Audit...take a guess at what oracle product the server is running..
AM_I_ORADB=`ps -ef | egrep -v "bash|grep" | egrep "ora_pmon|asm_pmon|tnslsnr" 1> /dev/null ; echo $?`
AM_I_ORAFMW=`ps -ef | egrep -v "bash|grep" | egrep "/opt/oracle|/software" | egrep "fmw" 1> /dev/null ; echo $?`
AM_I_ORAWLS=`ps -ef | egrep -v "bash|grep" | egrep "/opt/oracle|/software" | egrep "WebLogic" 1> /dev/null ; echo $?`
AM_I_RTAP=`ps -ef | egrep -v "bash|grep" | egrep "/opt/rtap" | egrep "rtap" 1> /dev/null; echo $?`
AM_I_UMDS=`ps -ef | egrep -v "bash|grep" | egrep "sunone/ldapinst/umds" 1> /dev/null; echo $?`
AM_I_PSKED=`ps -ef | egrep -v "bash|grep" | egrep "local/opt/g2" 1> /dev/null; echo $?`
AM_I_SPLUNK=`ps -ef | egrep -v "bash|grep" | egrep "splunkd" 1> /dev/null; echo $?`
AM_I_JAVA=`ps -ef | egrep -v "bash|grep" | egrep "java" 1> /dev/null; echo $?`
AM_I_GENSYM=`ps -ef | egrep -v "bash|grep" | egrep "Gensym" 1> /dev/null; echo $?`

        if [ $AM_I_ORADB = 0 ]; then
                ORADB=ORADB
        fi
        if [ $AM_I_ORAFMW = 0 ]; then
                ORAFMW=ORAFMW
        fi
        if [ $AM_I_ORAWLS = 0 ]; then
                ORAWLS=ORAWLS
        fi
       if [ $AM_I_RTAP = 0 ]; then
              RTAP=RTAP
       fi
       if [ $AM_I_UMDS = 0 ]; then
               UMDS=UMDS
       fi
       if [ $AM_I_PSKED = 0 ]; then
               PSKED=PSKED
       fi
       if [ $AM_I_SPLUNK = 0 ]; then
               SPLUNK=SPLUNK
       fi
       if [ $AM_I_JAVA = 0 ]; then
               JAVA=JAVA
       fi
       if [ $AM_I_GENSYM = 0 ]; then
               GENSYM=GENSYM
       fi

ORAGUESS=`echo $ORADB $ORAFMW $ORAWLS $RTAP $UMDS $PSKED $SPLUNK $JAVA $GENSYM`
if [ -z "$ORAGUESS" ]; then
       ORAGUESS=NA
fi


# Post processing uptime in case it is less than a day.  If it is, it will have a colon and that screws things up....
SCREWY=`echo $UPTIMEA | grep ":"`
        if [ -n "$SCREWY" ]; then
                UPTIME="0"
        else
                UPTIME="$UPTIMEA"
        fi

# Trying to determine if things are updated via patching, so the Linux Kernels are determined by comparing the output of uname -r to the list of current
# kernels below.  You have to update the list of current kernels on a periodic basis now...that sucks.
# Solaris 10 is done in a similar way.  We compare the SUNWcsr package time stamp.
 
##Q1_2016_CURRENT_KERNELS="2.6.18-409.el5|2.6.32-573.22.1.el6.x86_64|2.6.32-400.26.3.el5uek|2.6.39-400.277.1.el5uek|2.6.18-409.el5|on10-patch20160217152310|2.6.32-400.26.3.el5uek|2.6.39-400.215.9.el5uek| 2.6.39-400.277.1.el6uek.x86_64|B.11.31.1303.390|B.11.31.1603.421a|B.11.23.1012.086a|B.11.11.0912.483"

# RHEL7="3.10.0-693.2.2.el7.x86_64"  Q4 2017
RHEL7="3.10.0-693.21.1.el7.x86_64"
RHEL6="2.6.32-696.10.3.el6.x86_64"    # Q4-2017 Value
# RHEL6="2.6.32-696.el6.x86_64"    # Q2-2017 Value
RHEL5_32="2.6.18-419.el5PAE"
RHEL5_64="2.6.18-419.el5"
# OEL6UEK="2.6.39-400.284.2.el6uek" Q4-2017
OEL6UEK="4.1.12-103.7.1.el6uek.x86_64"
OEL5UEK="2.6.39-400.286.3.el5uek"
OEL6="2.6.32-642.4.2.el6"
OEL5="2.6.18-412"
# HPUX1131="B.11.31.1609.424"
HPUX1131="B.11.31.1709.431"
HPUX1123="Depricated"
HPUX1111="Depricated"
SOLARIS10="on10-patch20170424132433"
SOLARIS8="Depricated"
SOLARIS11="0.175.3.24.0.2.0"
AIX="1737A_71X"

# NOTE - all the variables below in current kernels have to be defined or the HPUX in GD will puke on the script
CURRENT_KERNELS="$RHEL7|$RHEL6|$RHEL5_32|$OEL6UEK|$OEL5UEK|$OEL6|$OEL5|$HPUX1131|$HPUX1123|$HPUX1111|$SOLARIS10|$SOLARIS8|$SOLARIS11|$AIX"
OBSOLETE="B.11.11|B.11.23|5.8|SUSE|WS release 4|AIX 6|Tikanga|Carthage|2.6.18-412|2.6.39-400.286.3.el5uek|2.6.18-419.el5"

case "$NWLOC" in

	1065[0-9][0-9]) LOCATION=MLP;;
#	1070[0-9][0-9][0-9]) LOCATION=MLP-SCADA;;
	1070[0-9][0-9][0-9]) LOCATION=MLP;;
#	1070[0-9][0-9]) LOCATION=MLP-SCADA;;
	1070[0-9][0-9]) LOCATION=MLP;;
	1065[0-9][0-9][0-9]) LOCATION=MLP;;
#	20734126) LOCATION=MLP-DMZ;;
	20734126) LOCATION=MLP;;
#	10722[0-9][0-9]) LOCATION=MLP-PL;;
	10722[0-9][0-9]) LOCATION=MLP;;
#	10721[5-7][0-9]) LOCATION=MLP-PL-EXA;;
	10721[5-7][0-9]) LOCATION=MLP;;
#    	107013[2-3]) LOCATION=MLP-SCADA;;
    	107013[2-3]) LOCATION=MLP;;
    	10666[0-9]) LOCATION=SEO;;
    	1066[4-7][0-4]) LOCATION=SEO;;
#    	1066[1-3][2-4][0-9]) LOCATION=SEO-PL;;
    	1066[1-3][2-4][0-9]) LOCATION=SEO;;
#    	106615[0-9]) LOCATION=SEO-PL-EXA;;
    	106615[0-9]) LOCATION=SEO;;
#    	106694) LOCATION=SEO-PL-VBLK;;
    	106694) LOCATION=SEO;;
#    	107013[6-9]) LOCATION=SEO-SCADA;;
    	107013[6-9]) LOCATION=SEO;;
#    	1611412) LOCATION=SEO-DMZ;;
    	1611412) LOCATION=SEO;;
#    	1070[0-32]) LOCATION=ENB2-SCADA;;
    	1070[0-32]) LOCATION=ENB2;;
#	1070128) LOCATION=REMOTE-PLC-SCADALab;;
	1070128) LOCATION=REMOTE;;
#	107064)	LOCATION=REMOTE-EDMTerm-SCADA;;
	107064)	LOCATION=REMOTE;;
	10170[0-9]) LOCATION=VPC;;
	10170[0-9][0-9]) LOCATION=VPC;;
	101783) LOCATION=VPC;;
#	10178242) LOCATION=VPC-DMZ;;
	10178242) LOCATION=VPC;;
	10179[0-9]) LOCATION=THOROLD;;
	10179[0-9][0-9]) LOCATION=THOROLD;;
	103[3-7][1-9][0-9][0-9]) LOCATION=LEBANON;;
	109[7-9][1-9][0-9][0-9]) LOCATION=DALLAS;;
	10101[0-9][0-9][0-9]) LOCATION=DALLAS;;
	103410) LOCATION=DALLAS;;
#	1022057) LOCATION=REMOTE-HOUSTON;;
	1022057) LOCATION=REMOTE;;
    	*)	LOCATION=REMOTE
    	;;
    esac

## Figure out auth mechanism and count root equivs if auth is centrify
COMP_ROLE="NA"   #Pre-populating this so it gets filled in regardless of what happens in the centrify section
if [ -f "/etc/nsswitch.conf" ]; then
	sed -n '/^passwd/p' /etc/nsswitch.conf > /dev/null 2>&1
              if [ $? = 0 ]; then
              AUTH=MF
              fi
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
	      ZONE=`adinfo --zone | awk -F"Global/" '{print $2}'`
	      COMP_ROLET=`dzinfo -Cf | egrep 'Computer Role' | awk -F: '{print $NF}' | sort -u`
              COMP_ROLE=`echo "("$ZONE")"$COMP_ROLET`
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

# Determine if facts are in place.
FACTSFILE='/etc/facter/facts.d/facts.txt'

	if [ -f $FACTSFILE ]; then
   	  FACTS=Y
		else
   	  FACTS=N
	fi

PUPPETFILE='/opt/puppetlabs/bin/puppet'

        if [ -f $PUPPETFILE ]; then
          PUPPET=Y
                else
          PUPPET=N
        fi


# Get the facts....
        if [ -f $FACTSFILE ]; then
          ENBAPPSUPPORT=`cat $FACTSFILE | grep enbappsupport | awk -F= '{print $2}'|sed 's/:/\|/g'` ;
          ENBSERVICE=`cat $FACTSFILE | grep enbservice | awk -F= '{print $2}'|sed 's/:/\|/g'` ;
          ENBSUBSERVICE=`cat $FACTSFILE | grep enbsubservice | awk -F= '{print $2}'|sed 's/:/\|/g'` ;
          ENBSTATUS=`cat $FACTSFILE | grep enbstatus | awk -F= '{print $2}'|sed 's/:/\|/g'` ; 
          ENBPTCHEXMPTN=`cat $FACTSFILE | grep enbptchexmptn | awk -F= '{print $2}'|sed 's/:/\|/g'`
	else
	  ENBAPPSUPPORT='NA' ;
	  ENBSERVICE='NA' ;
	  ENBSUBSERVICE='NA' ;
	  ENBSTATUS='NA'; 
	  ENBPTCHEXMPTN='NA' 
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
	INCEPTION=NA

	PROCS=`/sbin/ioscan -k | grep processor | wc -l`;
	CPROC="0";
	MEM=`echo "selclass qualifier memory;info;wait;infolog"| $CSTM | grep " System Total (MB)" | awk '{print $(NF)}'`;
	if [ -n "$MEM" ]; then
		MEMG=`echo "$MEM/1024" | bc`
		else
		MEMG=0
	fi
        
	KERNEL_LEVEL=`/usr/sbin/swlist -l bundle | grep -Ei 'GOLD|QPK'|grep -i base | awk '{print $2}'`;
        CURRENT=`echo $KERNEL_LEVEL | egrep "$CURRENT_KERNELS"`
	DEPRICATED=`echo $RUNAME | egrep "$OBSOLETE"`
        if [ -n "$CURRENT" ]; then
                UP2DATE="Y"
	elif [ -n "$DEPRICATED" ]; then
		UP2DATE="D"
        else
                UP2DATE="N"
        fi

	VERSION=`uname`;
	NUNAME=$KERNEL_LEVEL;
	PROC_TYPE=`uname -m` ;
	APPGUESS=`cat /etc/snmpd.conf | grep ^contact: | awk -F= '{print $3}'`;;



 Linux)	MODEL=`$DMIDECODE | grep -m 1 "Product Name" | awk -F\: '{print $2}'` ; 
	SERIAL=`$DMIDECODE | grep -m 1 "Serial Number" | awk -F\: '{print $2}'` ; 
   		if [ -f /etc/system-release ]; then
		TVERSION=`cat /etc/system-release`
		elif [ -f /etc/enterprise-release ]; then
		TVERSION=`cat /etc/enterprise-release`
		elif [ -f /etc/oracle-release ]; then
		TVERSION=`cat /etc/oracle-release`
		elif [ -f /etc/redhat-release ]; then
		TVERSION=`cat /etc/redhat-release`
		elif [ -f /etc/SuSE-release ]; then
		TVERSION=`cat /etc/SuSE-release| grep Linux`
		else
		TVERSION="Unspecified Linux"
		fi
	VERSION=`echo $TVERSION | sed 's/Red Hat Enterprise Linux/RHEL/g'| sed 's/release //g'`
#	ROOTPAR=`df / | awk '{print $1}' | grep "/"`
#	INCEPTION=`tune2fs -l $ROOTPAR | grep created`
	INCEPTION=`dmidecode | grep "Release Date:"| awk -F: '{print $2}'`
	KERNEL_LEVEL=`uname -r`;
	PAE=`uname -r | grep PAE`;

	if [ -n "$PAE" ]; then
   		PACKAGE='kernel-PAE'
		else
   		PACKAGE='kernel'
	fi
	KPDATE=`rpm -q $PACKAGE  --queryformat '%{installtime:date}\n' | tail -n 1 | sed 's/:/-/g'`

	CURRENT=`echo $CURRENT_KERNELS | egrep $KERNEL_LEVEL`
        DEPRICATED=`echo $VERSION | egrep "$OBSOLETE"`
	if [ -n "$CURRENT" ]; then
		UP2DATE="Y"
        elif [ -n "$DEPRICATED" ]; then
                UP2DATE="D"
	else 
		UP2DATE="N"
	fi

	NUNAME=`echo $KERNEL_LEVEL "("$KPDATE")"`;
	CPROC=`dmidecode -t4 | grep "Core Count" | sort -u | awk '{print $3}'`
	PROCS=`dmidecode -t4 | grep "Socket Designation" | sort -u | wc -l`
	PROC_TYPE=`cat /proc/cpuinfo | grep "model name" | sort -u | awk -F\: '{print $2}'`
	MEM=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`
	MEMG=`echo "$MEM/1000/1024" | bc`
	#APPGUESS=`cat /etc/snmp/snmpd.conf | grep ^syscontact | awk -F= '{print $3}'`;;
	APPGUESS=`cat /etc/snmp/snmpd.conf | grep "^syscontact *OS=" | awk -F= '{print $3}'`;;

  SunOS) if [ -c /dev/zconsole ]; then
		MODEL="NGC"
	else 
 		MODEL=`prtdiag | grep ^"System Configuration:" | awk -F: '{print $2}' | sed 's/Oracle Corporation  sun4.//g'| sed 's/Sun Microsystems  sun4.//g'|sed 's/SPARC Enterprise//g'|sed 's/Sun//g'`;
        fi
	INCEPTION=`ls -lE /var/sadm/system/logs/install_log | awk '{print $6}'`

	if [ -f "/usr/sbin/sneep" ]; then
		SERIAL=`/usr/sbin/sneep | awk '{print $1}'`
	else
		SERIAL="Not Detected"
	fi
	if [ $RUNAME = "5.11" ]; then
		KERNEL_LEVEL=`pkg info kernel | grep "Branch:" | awk '{print $2}'`
	else 
		KERNEL_LEVEL=`pkginfo -l SUNWcsr | grep PSTAMP | awk '{print $2}'`
	fi
	CURRENT=`echo $KERNEL_LEVEL | egrep "$CURRENT_KERNELS"`
	DEPRICATED=`echo $RUNAME | egrep "$OBSOLETE"`
        if [ -n "$CURRENT" ]; then
                UP2DATE="Y"
        elif [ -n "$DEPRICATED" ]; then
                UP2DATE="D"
        else
                UP2DATE="N"
        fi

	VUNAME=`uname -v`;
	
	NUNAME=`echo $VUNAME"("$KERNEL_LEVEL")"`;
	VERSION="$UNAME $RUNAME"
	PROCS=`psrinfo -p`
	CPROC=`psrinfo -pv | grep "virtual processors" | awk '{print $5}'| sort -u| tr '\n' ' ' | grep [0-9]`
	PROC_TYPE=`psrinfo -pv | grep SPARC | awk '{print $1 "@"$(NF-1)$(NF)}' | sed 's/)//g'| sort -u`
	MEM=`prtconf 2> /dev/null | grep "Memory size" | awk '{print $3}'`
	MEMG=`echo "$MEM/1024" | bc`
	APPGUESS=`egrep "OS=UNIX Server Support" /etc/sma/snmp/snmpd.conf | awk -F= '{print $3}'`;;

  AIX) 
	INCEPTION=NA
        PMODEL=`uname -M| sed s/,/-/g`;
#       MODEL="$SMODEL $VIOS";
        SERIAL=`uname -m`;
        VUNAME=`uname -v`;
	SUNAME=`uname -sv`;
#       KERNEL_LEVEL=`oslevel -s`;
        KERNEL_LEVEL=`cat /proc/version | grep buildinfo | awk '{print $NF}'`;
        VERSION="$UNAME $VNAME"
        NUNAME=`echo $UNAME" "$VUNAME"."$RUNAME" ("$KERNEL_LEVEL")"`;
        PROCS=`prtconf | grep ^"Number Of Processors:" | awk -F: '{print $2}'`
        CPROC="0"
        PROC_TYPE=`prtconf | grep -i "Processor Type" | awk -F: '{print $2}'`
        MEM=`prtconf 2> /dev/null | grep ^"Memory Size" | awk '{print $3}'`
        MEMG=`echo "$MEM/1024" | bc`
	
        CURRENT=`echo $KERNEL_LEVEL | egrep "$CURRENT_KERNELS"`
        DEPRICATED=`echo $SUNAME | egrep "$OBSOLETE"`
        if [ -n "$CURRENT" ]; then
                UP2DATE="Y"
        elif [ -n "$DEPRICATED" ]; then
                UP2DATE="D"
        else
                UP2DATE="N"
        fi
	if [ -e "/usr/ios/cli/ioscli" ]; then
		VIOS="VIO Server"
	fi

	LPAR=`prtconf -L | grep -v NULL`
	if [ -n "$LPAR" ]; then
		SMODEL=LPAR
        	MODEL="$SMODEL $VIOS on $PMODEL"
	else
		SMODEL=`uname -M| sed s/,/-/g`
		MODEL=$SMODEL
	fi
        APPGUESS=`egrep "OS=UNIX Server Support" /etc/snmpd.conf | awk -F= '{print $3}'`;;
		

 *)      printf SOMETHINGELSE;;
esac

# Uncomment below to get oracle procs...after editting the monthly_sumary file.
#echo      "$DATE , $HOSTNAME , $LOCATION , $UPTIME , $AUTH , $VERSION , $NUNAME , $MODEL , $APPGUESS , $IPADDR , $SERIAL , $PROCS , $CPROC , $PROC_TYPE , $MEMG , $USERS , $UP2DATE , $COMP_ROLE , $ORA_PROCS , $ORAGUESS "
echo      "$DATE , $HOSTNAME , $LOCATION , $UPTIME , $AUTH , $VERSION , $NUNAME , $MODEL , $APPGUESS , $ENBAPPSUPPORT , $ENBSERVICE, $ENBSUBSERVICE , $ENBSTATUS , $ENBPTCHEXMPTN , $IPADDR , $SERIAL , $PROCS , $CPROC , $PROC_TYPE , $MEMG , $USERS , $UP2DATE , $COMP_ROLE , $FACTS , $PUPPET , $ORA_PROCS , $ORAGUESS , $INCEPTION "
