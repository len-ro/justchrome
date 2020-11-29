#!/bin/bash

RUNDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$#" -eq 1 ]; then
    #media
    MEDIA=$1
    echo "Creating docker using persistent storage $MEDIA!"
    $RUNDIR/docker/run.sh -b $RUNDIR -i len/justchrome:1.0 -n $MEDIA -s chrome.sh
else
    #disposable
    echo "Creating disposable browser, your session will be deleted on exit!"
    $RUNDIR/docker/run.sh -b $RUNDIR -t -i len/justchrome:1.0 -s chrome.sh
fi