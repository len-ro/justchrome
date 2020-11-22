#!/bin/bash

RUNDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$RUNDIR/docker/run.sh -t -i len/justchrome:1.0 -s chrome.sh

