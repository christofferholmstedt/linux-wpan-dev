#!/bin/bash

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


if [ -d "bluetooth-next" ]; then
	#############################################
	# Patch linux-kernel and device trees
	#############################################
	echo "[INFO]"
	echo "[INFO] Patch linux-kernel"
	echo "[INFO]"
	cd bluetooth-next

	git apply $SCRIPT_DIR/linux_kernel_patches/0001-arm-dts-Update-RPi-B-dts-for-Openlabs-802.15.4-trans.patch

	#############################################
	# Configure linux kernel
	#############################################
	echo "[INFO]"
	echo "[INFO] Copy configuration file for linux-kernel"
	echo "[INFO]"
	cp -v $SCRIPT_DIR/.config-rpi-b-linux-openlabs-no-modules .config

	#############################################
	# Compile linux kernel
	#############################################
	echo "[INFO]"
	echo "[INFO] Compile linux-kernel"
	echo "[INFO]"
	CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm make -j4
	CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm make modules -j4
	CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm INSTALL_MOD_PATH=.mods make modules_install -j4

	#############################################
	# Compile device tree
	#############################################
	CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm make dtbs -j4

	cd ..
fi

if [ -d "u-boot" ]; then
	cd u-boot

	#############################################
	# Configure U-Boot
	#############################################
	echo "[INFO]"
	echo "[INFO] Copy configuration file for U-Boot"
	echo "[INFO]"
	cp -v $SCRIPT_DIR/.config-rpi-b-u-boot .config

	#############################################
	# Compile U-Boot
	#############################################
	echo "[INFO]"
	echo "[INFO] Compile U-Boot"
	echo "[INFO]"
	CROSS_COMPILE=arm-linux-gnueabi- make -j4

	cd ..
fi

if [ -d "output" ]; then
	rm -rvf output/
fi

if [ ! -d "output" ]; then
	#############################################
	# Copy all artifacts to one folder
	#############################################
	echo "[INFO]"
	echo "[INFO] Copying all artifacts to final destination"
	echo "[INFO]"
	mkdir -pv output/lib/modules
	cd output
	cp -v ../bluetooth-next/arch/arm/boot/zImage .
	cp -v ../bluetooth-next/arch/arm/boot/dts/bcm2835-rpi-b.dtb zImage.dtb
	cp -r ../bluetooth-next/.mods/lib/modules/* lib/modules
	cp -v ../u-boot/u-boot.bin kernel.img
	cd ..
fi

###
# Create uEnv.txt
#
# The boot=/dev/mmcblk0p2 describes where the kernel is located and
# it is crucial it points to correct place. We can find this information from
# the old Raspbian installation /boot/comandline.txt
#
# If it's not mmcblk0p2 for you, change this script and re-run it (or just
# change the uEnv.txt file).
###
OUTPUT_FILE=./output/uEnv.txt
if [ ! -f $OUTPUT_FILE ]; then
cat >> $OUTPUT_FILE << 'EOL'
bootargs=earlyprintk console=tty0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 root=/dev/mmcblk0p2 rootwait dwc_otg.lpm_enable=0
bootcmd=load mmc 0:1 ${kernel_addr_r} zImage; load mmc 0:1 ${fdt_addr_r} zImage.dtb; bootz ${kernel_addr_r} - ${fdt_addr_r}
EOL
fi
