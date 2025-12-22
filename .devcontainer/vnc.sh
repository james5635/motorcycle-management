#!/usr/bin/env bash
# Start a VNC server and keep it running
sudo chmod 666 /dev/kvm
sudo apt update
sudo apt install -y --no-cache \
  xfce4 xfce4-goodies \
  tigervnc-standalone-server \
  novnc websockify dbus-x11
mkdir -p ~/.vnc
cat << EOF > ~/.vnc/xstartup
#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=XFCE
export XDG_SESSION_DESKTOP=XFCE

exec startxfce4 
EOF
chmod +x ~/.vnc/xstartup
# vncserver -localhost no :1 -geometry 1280x800
# vncserver -geometry 1920x1080
# vncserver -geometry 1280x720
vncserver -geometry 1366x768

