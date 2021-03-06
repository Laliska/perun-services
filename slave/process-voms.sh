#!/bin/bash

# Script for managing user membership in VOs

PROTOCOL_VERSION='3.1.0'

function process {

	EXECSCRIPT="${SCRIPTS_DIR}/voms/process-voms.pl"

	create_lock

	FROM_PERUN="${WORK_DIR}/voms"

	perl $EXECSCRIPT < $FROM_PERUN

	exit $?
}
