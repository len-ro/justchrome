#!/bin/bash

RUNDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGDIR=logs

cd $RUNDIR
mkdir -p $LOGDIR

if [ "$#" -eq 1 ]; then
    #media
    MEDIA=$1
    echo "Creating docker using persistent storage $MEDIA!"
    nohup $RUNDIR/docker/run.sh -b $RUNDIR -k -i len/justchrome:1.0 -n $MEDIA -s chrome.sh > $LOGDIR/$MEDIA.log 2>&1
else
    #disposable
    echo "Creating disposable browser, your session will be deleted on exit!"
    nohup $RUNDIR/docker/run.sh -b $RUNDIR -t -i len/justchrome:1.0 -s chrome.sh > $LOGDIR/disposable.log 2>&1
fi
