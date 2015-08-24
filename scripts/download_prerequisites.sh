#!/bin/bash

#############################################
# Download required files
#############################################

if [ ! -d "bluetooth-next" ]; then
	echo "[INFO]"
	echo "[INFO] Cloning bluetooth-next"
	echo "[INFO]"
	git clone https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git

	cd bluetooth-next
	git checkout -b bluetooth-next_temp 24add0cc07a88568da9345840a4f221ee0aefbb6
	cd ..
fi

if [ ! -d "u-boot" ]; then
	echo "[INFO]"
	echo "[INFO] Cloning U-Boot"
	echo "[INFO]"
	git clone https://github.com/swarren/u-boot.git

	cd u-boot
	git checkout -b rpi_temp 4f70244e0a1a0d68cf3c5493998ff3565f38d825
	sed -i 's/MMC_MODE_HS_52MHz | //' drivers/mmc/sdhci.c
	cd ..
fi
