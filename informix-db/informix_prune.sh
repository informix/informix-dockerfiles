HOME_DIR=/opt/hcl/informix

DIRS="
jdbc
JDBC
uninstall
isa
SDK
CSDK
ICONNECT
IBM_Data_Server_Driver_Package
demo
bin/plugins
release
extend/krakatoa
extend/N*
extend/TSP*
bin/about_files
"


FILES="
ids_install
*.log
bin/ifxguard
bin/blademgr
bin/onrestorept
bin/ifxclone
bin/ifxdeploy
bin/onconfig_diff
bin/db2dbgm.jar
bin/ifxbkpcloud.jar
"

EXTRA_FILES="
bin/archecker
bin/dbaccessdemo*
bin/check_version
bin/chkenv
bin/crtcmap
bin/dbexport
bin/dbimport
bin/dbload
bin/dbschema
bin/drdaprint
bin/esql
bin/idsd
bin/ifxcollect
bin/ifxdeployassist
bin/ifxpipecat
bin/onbar
bin/onbar_d
bin/ondblog
bin/onpsm
bin/onpassword
bin/onperf
bin/onlog
bin/onsmsync
bin/onsnmp
bin/onsrvapd
bin/ontape
bin/sqliprint
bin/txbsapswd
bin/unloadshp
bin/xtace
bin/xtree
lib/libdwa.udr
lib/libxml.udr
"

for i in $DIRS
do
echo rm -rf $HOME_DIR/$i
rm -rf $HOME_DIR/$i
done

for i in $FILES
do
echo rm -f $HOME_DIR/$i
rm -f $HOME_DIR/$i
done



for i in $EXTRA_FILES
do
echo rm -f $HOME_DIR/$i
rm -f $HOME_DIR/$i
done




