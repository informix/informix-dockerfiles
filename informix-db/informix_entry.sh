#!/bin/bash
#
#  name:        informix_entry.sh:
#  description: Starts Informix in Docker container
#


main()
{
###
###  Setup environment
###
trap finish_shutdown SIGHUP SIGINT SIGTERM SIGKILL

. /opt/hcl/scripts/informix_inf.env
dt=`date`
MSGLOG ">>>    Starting container/image ($dt) ..." N


###
###  Check LICENSE 
###
# if (! isLicenseAccepted)  
# then
#    MSGLOG ">>>    License was not accepted Exiting! ..." N
#    exit
# fi




###
###  Starting ssh
###
MSGLOG ">>>    Starting sshd ..." N
sudo service ssh start

###
### Add env script to ~informix/.bashrc 
### 
if (isNotInitialized)  
then
   printf "\n" >> ~informix/.bashrc
   printf ". $BASEDIR/scripts/informix_inf.env\n" >> ~informix/.bashrc 
else
   cnt=`grep informix_inf ~informix/.bashrc|wc -l`
   if [[ $cnt = "0" ]];
   then
      printf "\n" >> ~informix/.bashrc
      printf ". $BASEDIR/scripts/informix_inf.env\n" >> ~informix/.bashrc 
   fi
fi


###
### Setup INFORMIX_DATA_DIR 
### 
if (isNotInitialized)
then
   MSGLOG ">>>    Create data dirs ..." N
   MSGLOG ">>>        [$INFORMIX_DATA_DIR]" N
   . $SCRIPTS/informix_setup_datadir.sh
   MSGLOG "       [COMPLETED]" N
fi

###
### Setup sqlhosts file
### 
if (isNotInitialized)
then
   MSGLOG ">>>    Create sqlhosts file ..." N
   MSGLOG ">>>        [$INFORMIXSQLHOSTS]"  N
   . $SCRIPTS/informix_setup_sqlhosts.sh
fi
MSGLOG "       [COMPLETED]" N 


###
### Setup $ONCONFIG file
### 
if (isNotInitialized)
then
   if (setupUserOnconfig)
   then
      MSGLOG ">>>    Using custom ONCONFIG file ..." N 
      MSGLOG ">>>        [/home/informix/vol1/$DB_ONCONFIG]" N 
      . $SCRIPTS/informix_setup_user_onconfig.sh
   else
      MSGLOG ">>>    Create ONCONFIG file ..."  N
      MSGLOG ">>>        [$INFORMIXDIR/etc/$ONCONFIG]" N  
      . $SCRIPTS/informix_setup_onconfig.sh
   fi
   MSGLOG "       [COMPLETED]" N 
fi



###
### Setup links $ONCONFIG and SQLHOSTS into $INFORMIXDIR/etc 
### 
MSGLOG ">>>    Creating Links for sqlhosts/ONCONFIG " N 
. $SCRIPTS/informix_setup_links.sh


###
### Update $HOSTNAME in various file(s) 
### 

MSGLOG ">>>    Updating HOSTNAME in file(s)..." N
MSGLOG ">>>        [$INFORMIXSQLHOSTS]"  N
. $SCRIPTS/informix_update_hostname.sh
MSGLOG "       [COMPLETED]" N 


###
### Setup MSGPATH 
### 
if (isNotInitialized)
then
   MSGLOG ">>>    Create MSGPATH file ..." N
   MSGLOG ">>>        [$INFORMIX_DATA_DIR/logs/online.log]" N
   . $SCRIPTS/informix_setup_msgpath.sh
   MSGLOG "       [COMPLETED]" N 
fi


###
### Setup rootdbs 
### 
if (isNotInitialized)
then
   MSGLOG ">>>    Create rootdbs ..." N
   MSGLOG ">>>        [$INFORMIX_DATA_DIR/spaces/rootdbs.000]" N
   . $SCRIPTS/informix_setup_rootdbs.sh
   MSGLOG "       [COMPLETED]" N
fi



###
### Initialize Instance - First time initialize disk space 
### 
if (isNotInitialized)
then
   MSGLOG ">>>    Informix DISK Initialization ..." N
   . $SCRIPTS/informix_init.sh
else
   MSGLOG ">>>    Informix SHM Initialization ..." N
   . $SCRIPTS/informix_online.sh
fi
MSGLOG "       [COMPLETED]" N


###
### Setup DB - 
### 



###
### Setup Wire Listeners  - 
### 
. $SCRIPTS/informix_wl.sh


###
### Execute the entrypoint_initdb scripts 
### 
exec_S_initdb

###
### Set $INFORMIX_DATA_DIR/.initialized
### 
if (isNotInitialized);
then
   touch $INFORMIX_DATA_DIR/.initialized
fi


printf "\n"|tee -a $INIT_LOG
printf "\t###############################################\n"|tee -a $INIT_LOG
printf "\t# Informix container login Information:        \n"|tee -a $INIT_LOG
printf "\t#   user:            informix                  \n"|tee -a $INIT_LOG
printf "\t#   password:        $DB_PASS                  \n"|tee -a $INIT_LOG
printf "\t###############################################\n"|tee -a $INIT_LOG
printf "\n"


### run interactive shell now it is done in Dockerfile
printf "###    Type exit to quit the Startup Shell\n"|tee -a $INIT_LOG
printf "###       This will stop the container\n" |tee -a $INIT_LOG
printf "\n"|tee -a $INIT_LOG
printf "###    For interactive shell run:\n"|tee -a $INIT_LOG
printf "###      docker exec -it ${HOSTNAME} bash\n"|tee -a $INIT_LOG
printf "\n"|tee -a $INIT_LOG
printf "###    To start the container run:\n"|tee -a $INIT_LOG
printf "###      docker start ${HOSTNAME} \n"|tee -a $INIT_LOG
printf "\n"|tee -a $INIT_LOG
printf "###    To safely shutdown the container run:\n"|tee -a $INIT_LOG
printf "###      docker stop ${HOSTNAME} \n"|tee -a $INIT_LOG
printf "\n"|tee -a $INIT_LOG


finish_org
finish_shutdown

}



#####################################################################
### FUNCTION DEFINITIONS
#####################################################################

SUCCESS=0
FAILURE=-1

###
### exec_S_initdb 
###
function exec_S_initdb()
{
MSGLOG ">>>    Execute init-startup scripts" N

if [ -d $INFORMIX_DATA_DIR/informix-entrypoint-initdb.d ]
then
   filelist=`ls -x $INFORMIX_DATA_DIR/informix-entrypoint-initdb.d/S*`
   for f in $filelist
   do
   MSGLOG ">>>        File: $f" N
   done
fi
MSGLOG "       [COMPLETED]" N
}


###
### exec_K_initdb 
###
function exec_K_initdb()
{
MSGLOG ">>>    Execute init-shutdown scripts" N

if [ -d $INFORMIX_DATA_DIR/informix-entrypoint-initdb.d ]
then
   filelist=`ls -x $INFORMIX_DATA_DIR/informix-entrypoint-initdb.d/K*`
   for f in $filelist
   do
   MSGLOG ">>>        File: $f" N
   done
fi
MSGLOG "       [COMPLETED]" N
}




function isLicenseAccepted()
{
uLICENSE=`echo $LICENSE|tr /a-z/ /A-Z/`
if [[ $uLICENSE = "ACCEPT" ]];
then
   return $SUCCESS
else
   return $FAILURE 
fi
}


###
### isNotInitialized 
###
function isNotInitialized()
{
dt=`date`
if [ ! -e $INFORMIX_DATA_DIR/.initialized ];
then
   MSGLOG ">>>    DISK INITIALIZING ($dt) ..." N 
   return $SUCCESS
else
   MSGLOG ">>>    DISK ALREADY INITIALIZED ($dt) ..." N 
   return $FAILURE 
fi
}


###
### setupUserOnconfig 
###
function setupUserOnconfig()
{
if [ $DB_ONCONFIG ];
then
   return $SUCCESS
else
   return $FAILURE 
fi
}


###
### MSGLOG 
###
function MSGLOG()
{

if [ ! -e $INIT_LOG ]
then
   touch $INIT_LOG
fi

if [[ $2 = "N" ]]
then
   printf "%s\n" "$1" |tee -a $INIT_LOG
else
   printf "%s" "$1" |tee -a $INIT_LOG
fi
}


function finish_org()
{
trap finish_shutdown SIGHUP SIGINT SIGTERM SIGKILL
tail -f  $INFORMIX_DATA_DIR/logs/online.log
wait $!

}

function finish_shutdown()
{
MSGLOG ">>> " N
MSGLOG ">>>    SIGNAL received - Shutdown:" N
MSGLOG ">>> " N
. $BASEDIR/scripts/informix_stop.sh
}





###
###  Call to main
###
main "$@"
