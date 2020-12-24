#!/bin/bash

RUNDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $RUNDIR

#config
DISPLAY_NO=700
DOCKER_USER=chrome

#params
DOCKER_IMAGE=len/justchrome:1.0
TEMP_RUN=false
INSTANCE_NAME=chrome
RUN_SCRIPT=chrome.sh

while getopts 'i:tn:s:b:k' c
do
  case $c in
    i) DOCKER_IMAGE=$OPTARG ;;
    t) TEMP_RUN=true ;;
    n) INSTANCE_NAME=$OPTARG ;;
    s) RUN_SCRIPT=$OPTARG ;;
    b) BASE_PATH=$OPTARG ;;
    k) KEEPASSXC=true ;;
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

nxagent :$DISPLAY_NO -ac -R -noshmem -noreset -norootlessexit &
XNEST_PID="$!"
echo Started X $XNEST_PID on display $DISPLAY_NO

sleep 1

export DISPLAY=:$DISPLAY_NO

if [ "x$TEMP_RUN" = "xtrue" ]; then
    INSTANCE_NAME=disposable-$DISPLAY_NO
fi

STORAGE_DIR=$BASE_PATH/storage/$INSTANCE_NAME

mkdir -p $STORAGE_DIR
cp $RUN_SCRIPT $STORAGE_DIR/start.sh

if [ "x$KEEPASSXC" = "xtrue" ]; then
    echo Enabling keepassxc-browser
    cp org.keepassxc.keepassxc_browser.json $STORAGE_DIR/.config/google-chrome/NativeMessagingHosts
fi

echo "Running in docker $RUN_SCRIPT from $STORAGE_DIR"

cleanup_exit(){
    echo Cleanup called
    sleep 1
    kill $XNEST_PID
    if [ "x$TEMP_RUN" = "xtrue" ]; then
	    rm -rf $STORAGE_DIR
    fi
    sudo rm -rf /tmp/.X11-unix/X$DISPLAY_NO
    echo All clean!
}

trap "cleanup_exit" SIGINT SIGQUIT SIGTERM EXIT

docker run -v /tmp/.X11-unix/X$DISPLAY_NO:/tmp/.X11-unix/X$DISPLAY_NO -e DISPLAY=$DISPLAY -v /run/user/$UID/pulse/native:/home/$DOCKER_USER/pulse -v $STORAGE_DIR:/home/$DOCKER_USER -v /run/user/$UID/org.keepassxc.KeePassXC.BrowserServer:/tmp/org.keepassxc.KeePassXC.BrowserServer --security-opt=seccomp=chrome.json --device /dev/dri --name $INSTANCE_NAME -h $INSTANCE_NAME --rm $DOCKER_IMAGE

#-v /run/user/$UID/org.keepassxc.KeePassXC.BrowserServer:/tmp/runtime-chrome/org.keepassxc.KeePassXC.BrowserServer
