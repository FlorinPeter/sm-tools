#!/bin/bash

# $Id$

# This script's first argument should be a uuid (e.g. $uuid from an NNM
# incident). This will be searched for in the description field.
# 
# The second argument should be whatever you want to the
# description field to say (onto which the uuid will be appended);
# if it is blank or "-" then description won't be updated.
#
# Any remaining arguments will be passed to sm-update-incident.py or
# sm-create-incident.py.

UUID=$1
DESCRIPTION=$2
shift
shift

if [ "$DESCRIPTION" = "-" ]
then
 DESCRIPTION=""
fi

PATH=/var/opt/OV/shared/nnm/actions:$PATH

INCIDENTS=$(smcli.py search incidents --description="*uuid=$UUID*")

if [ "$INCIDENTS" = "" ]
then
  smcli.py create incident --description="$DESCRIPTION  uuid=$UUID" "$@"
else
    if [ "$DESCRIPTION" = "" ]
    then
	smcli.py create incident --incident-id=$INCIDENTS "$@"
    else
	smcli.py update incident --incident-id=$INCIDENTS --description="$DESCRIPTION  uuid=$UUID" "$@"
    fi
fi
