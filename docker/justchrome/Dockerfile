#build as
#docker build -t len/justchrome:1.0  .
#
#run via main.sh

FROM ubuntu:20.04
MAINTAINER len@len.ro

#install google-chrome
RUN apt-get update && apt-get install -y wget pulseaudio gnupg && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && apt-get update && apt-get upgrade -y && apt-get install -y google-chrome-stable

#install other stuff
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y xterm nxproxy libnx-x11-6 libnxcl-bin
#nxagent xpra xserver-xorg-video-dummy fluxbox
#dbus: dbus dbus-user-session dbus-x11

#install keepassxc
RUN apt-get install -y software-properties-common && add-apt-repository ppa:phoerious/keepassxc && apt-get update && apt-get install -y keepassxc

#install skype
#RUN apt-get install -y libsecret-1.0 gnome-keyring libxss1 && wget -c https://go.skype.com/skypeforlinux-64.deb && dpkg -i skypeforlinux-64.deb

#clean
RUN rm -rf /var/cache/apt/archives/*

RUN useradd -m -s /bin/bash -u 1000 chrome

#disable first run message
#RUN mkdir -p /home/chrome/.config/google-chrome && touch /home/chrome/.config/google-chrome/"First Run" && chown -R chrome /home/chrome

USER chrome
ENV PULSE_SERVER /home/chrome/pulse

#COPY --chown=chrome:chrome env/start.sh /home/chrome/

#chrome settings
COPY duckduckgo.json /etc/opt/chrome/policies/recommended/duckduckgo.json
COPY extensions.json /etc/opt/chrome/policies/managed/extensions.json

WORKDIR /home/chrome
ENTRYPOINT [ "/home/chrome/start.sh" ]
