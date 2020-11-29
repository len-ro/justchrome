#!/bin/bash

RUNDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$RUNDIR/docker/run.sh -b $RUNDIR -i len/justchrome:1.0 -n media -s chrome.sh

