#!/bin/bash
#
#  name:        informix_setup_onconfig.sh:
#  description: Setup the onconfig file 
#  Called by:   informix_entry.sh


#ONCONFIG_PATH=$INFORMIXDIR/etc/$ONCONFIG
ONCONFIG_PATH=$INFORMIX_DATA_DIR/links/$ONCONFIG
if [ -e $INFORMIX_DATA_DIR/$ONCONFIG ]
then
   MSGLOG ">>>        Using $ONCONFIG supplied by user" N
   mv $INFORMIX_DATA_DIR/$ONCONFIG $ONCONFIG_PATH
   sudo chown informix:informix $ONCONFIG_PATH
   sudo chmod 660 $ONCONFIG_PATH
else
   MSGLOG ">>>        Using default $ONCONFIG" N
   cp $INFORMIXDIR/etc/onconfig.std $ONCONFIG_PATH
fi

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
sed -i "s#^SBSPACENAME.*#SBSPACENAME sbspace#g"               "${ONCONFIG_PATH}"


sudo chown informix:informix "${ONCONFIG_PATH}"
sudo chmod 660 "${ONCONFIG_PATH}"

