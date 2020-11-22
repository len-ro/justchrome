#!/bin/bash

RUNDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $RUNDIR

#config
DISPLAY_NO=700
BASE_PATH=$HOME/Private/contained
DOCKER_USER=chrome

#params
DOCKER_IMAGE=len/justchrome:1.0
TEMP_RUN=false
INSTANCE_NAME=chrome
RUN_SCRIPT=chrome.sh

while getopts 'i:tn:s:' c
do
  case $c in
    i) DOCKER_IMAGE=$OPTARG ;;
    t) TEMP_RUN=true ;;
    n) INSTANCE_NAME=$OPTARG ;;
    s) RUN_SCRIPT=$OPTARG ;;
  esac
done

#check params
if [ ! -x $RUN_SCRIPT ]; then
    echo Cannot find $RUNDIR/$RUN_SCRIPT
    exit -1
fi

echo Running instance $INSTANCE_NAME with script $RUN_SCRIPT on image $DOCKER_IMAGE, temporary $TEMP_RUN

#find first free display
while [ -e /tmp/.X11-unix/X$DISPLAY_NO ]; do
    let DISPLAY_NO=$DISPLAY_NO+1
done

#Xephyr :$DISPLAY_NO -screen 1400x1000 -resizeable -extension MIT-SHM -noreset -terminate &
#Xephyr :$DISPLAY_NO -ac -fullscreen -extension MIT-SHM -noreset -terminate &

nxagent :$DISPLAY_NO -ac -R -noshmem &
XNEST_PID="$!"
echo Started X $XNEST_PID on display $DISPLAY_NO

sleep 1

export DISPLAY=:$DISPLAY_NO

if [ "x$TEMP_RUN" = "xtrue" ]; then
    INSTANCE_NAME=disposable-$DISPLAY_NO
fi

mkdir -p $BASE_PATH/$INSTANCE_NAME
cp $RUN_SCRIPT $BASE_PATH/$INSTANCE_NAME/start.sh

echo Running $RUN_SCRIPT from $BASE_PATH/$INSTANCE_NAME

cleanup_exit(){
    sleep 1
    kill $XNEST_PID
    if [ "x$TEMP_RUN" = "xtrue" ]; then
	rm -rf $BASE_PATH/$INSTANCE_NAME
    fi
    sudo rm -rf /tmp/.X11-unix/X$DISPLAY_NO
    echo All clean!
}

trap "cleanup_exit" SIGINT SIGQUIT SIGTERM EXIT

docker run -it -v /tmp/.X11-unix/X$DISPLAY_NO:/tmp/.X11-unix/X$DISPLAY_NO -e DISPLAY=$DISPLAY -v /run/user/$UID/pulse/native:/home/$DOCKER_USER/pulse -v $BASE_PATH/$INSTANCE_NAME:/home/$DOCKER_USER --security-opt=seccomp=chrome.json --device /dev/dri --name $INSTANCE_NAME -h $INSTANCE_NAME --rm $DOCKER_IMAGE

#-v /run/user/$UID/org.keepassxc.KeePassXC.BrowserServer:/tmp/runtime-chrome/org.keepassxc.KeePassXC.BrowserServer
