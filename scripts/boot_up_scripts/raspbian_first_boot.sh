#!/bin/bash

#############################################
# Must run this script with sudo
#
# Download required files
#############################################

### Install required packages (netlink dev, generic netlink dev)
apt-get update
apt-get install -y bison flex autoconf libtool help2man libnl-3-dev \
	libnl-genl-3-dev

if [ ! -d "wpan-tools" ]; then
	echo "[INFO]"
	echo "[INFO] Cloning wpan-tools"
	echo "[INFO]"
	git clone https://github.com/linux-wpan/wpan-tools.git

	cd wpan-tools
	git checkout -b wpan-tools_temp wpan-tools-0.4
	cd ..
fi

### Disable ifplugd for all interfaces except eth0
sed -i 's/INTERFACES="auto"/INTERFACES="eth0"/g' /etc/default/ifplugd
sed -i 's/HOTPLUG_INTERFACES="all"/HOTPLUG_INTERFACES="eth0"/g' /etc/default/ifplugd
