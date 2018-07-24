#!/bin/bash
#
#  name:        informix_status.sh:
#  description: Check the status of Informix engine 
#  Called by:   HEALTHCHECK (docker) 


. /opt/hcl/scripts/informix_inf.env
onstat -
rc=$?

if [ ${rc} != 5 ];then
	exit 1
else
	exit 0
fi


