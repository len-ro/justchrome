# justchrome

Isolate chrome by running in a docker container with a separate X server.

## How to use

1. Create a persistent chrome running in a temporary docker. Storage in storage/media. Persistency is achieved by mapping the /home/chrome with storage/media 
```
$ justchrome.sh media 
```

2. Create a disposable chrome
```
$ justchrome.sh
```

## History:
- Initial dockerfile based on [jezzfraz](https://github.com/jessfraz/dockerfiles).
- added a separate X server for sandboxing. See [escaping X11](https://mjg59.dreamwidth.org/42320.html). Tried Xephyr and Xpra but finally settled with nxagent for the rootless mode and shared clipboard (no need for xclip)
- added chrome initial config based on policies (see extensions.json and duckduckgo.json)
- added support for keepassxc via socket forwarding
- added timezone support
- added open link support

# Required packages on host

```
docker, nxagent
```

# Setup and run

```
len@tux:~/justchrome$ cd docker/justchrome/
len@tux:~/justchrome/docker/justchrome$ docker build -t len/justchrome:1.0  .
len@tux:~/justchrome/docker/justchrome$ cd ../..
len@tux:~/justchrome$ ./justchrome.sh media
```

# Modify

1. **justchrome/docker/justchrome/Dockerfile** - change user id (default 1000), add packages
2. **justchrome/docker/run.sh** - this script starts the X11 server and the docker
3. **justchrome/justchrome.sh** - wrapper script for run.sh

# Setup open link in chrome

To open a link in your already open browser from outside the container use the open-link.sh as your default browser app. It will just run xdg-open in your docker thus opening the link in the open browser.