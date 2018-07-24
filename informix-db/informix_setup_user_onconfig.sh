#!/bin/bash
#
#  name:        informix_setup_user_onconfig.sh:
#  description: Setup a user supplied onconfig file 
#  Called by:   informix_entry.sh


ONCONFIG_PATH=$INFORMIXDIR/etc/onconfig
#cp $INFORMIXDIR/etc/onconfig.std $ONCONFIG_PATH
cp /home/informix/vol1/$DB_ONCONFIG $ONCONFIG_PATH 

E_ROOTPATH=$INFORMIX_DATA_DIR/spaces/rootdbs.000
E_CONSOLE=$INFORMIX_DATA_DIR/logs/console.log
E_MSGPATH=$INFORMIX_DATA_DIR/logs/online.log
E_DBSERVERNAME=informix
E_TAPEDEV=/dev/null
E_LTAPEDEV=/dev/null


sed -i "s#^ROOTPATH .*#ROOTPATH $E_ROOTPATH#g"               "${ONCONFIG_PATH}"
sed -i "s#^CONSOLE .*#CONSOLE $E_CONSOLE#g"                  "${ONCONFIG_PATH}"
sed -i "s#^MSGPATH .*#MSGPATH $E_MSGPATH#g"                  "${ONCONFIG_PATH}"
sed -i "s#^DBSERVERNAME.*#DBSERVERNAME $E_DBSERVERNAME#g"    "${ONCONFIG_PATH}"
sed -i "s#^DBSERVERALIASES.*#DBSERVERALIASES $E_DBSERVERNAME_dr#g"         "${ONCONFIG_PATH}"
sed -i "s#^TAPEDEV .*#TAPEDEV   $E_TAPEDEV#g"                "${ONCONFIG_PATH}"
sed -i "s#^LTAPEDEV .*#LTAPEDEV $E_LTAPEDEV#g"               "${ONCONFIG_PATH}"
sed -i "s#^DEF_TABLE_LOCKMODE page#DEF_TABLE_LOCKMODE row#g" "${ONCONFIG_PATH}"


chown informix:informix "${ONCONFIG_PATH}"
chmod 660 "${ONCONFIG_PATH}"

