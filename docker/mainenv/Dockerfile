#build as
#docker build -t len/justchrome:1.0  .
#
#run via main.sh

FROM ubuntu:20.04
MAINTAINER len@len.ro

RUN apt-get update && apt-get upgrade -y && apt-get install -y wget pulseaudio gnupg

#install google-chrome
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && apt-get update && apt-get install -y google-chrome-stable

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y xterm

#install keepassxc
#RUN add-apt-repository ppa:phoerious/keepassxc && apt-get update && apt-get install -y keepassxc

#RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository ppa:phoerious/keepassxc && apt-get update && apt-get install -y keepassxc fluxbox libsecret-1.0 gnome-keyring dbus dbus-user-session dbus-x11 xterm

#install skype
RUN apt-get install -y libsecret-1.0 gnome-keyring libxss1 && wget -c https://go.skype.com/skypeforlinux-64.deb && dpkg -i skypeforlinux-64.deb

#install other stuff
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y xterm fluxbox dbus dbus-user-session dbus-x11 xterm xpra nxproxy nxagent libnx-x11-6 libnxcl-bin xpra xserver-xorg-video-dummy fluxbox  

#clean
RUN rm -rf /var/cache/apt/archives/*

RUN useradd -m -s /bin/bash -u 1000 sandbox

#disable first run message
#RUN mkdir -p /home/sandbox/.config/google-chrome && touch /home/sandbox/.config/google-chrome/"First Run" && chown -R chrome /home/chrome

USER sandbox
ENV PULSE_SERVER /home/sandbox/pulse

#COPY --chown=sandbox:sandbox start.sh /home/sandbox/

WORKDIR /home/sandbox
ENTRYPOINT [ "/home/sandbox/start.sh" ]
