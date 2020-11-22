#!/bin/bash

RUNDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$RUNDIR/docker/run.sh -i len/justchrome:1.0 -n media -s chrome.sh

