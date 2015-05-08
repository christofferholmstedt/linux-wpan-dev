#!/bin/bash

if [ -d "wpan-tools" ]; then
	#############################################
	# Compile wpan-tools
	#############################################
	echo "[INFO]"
	echo "[INFO] Compile wpan-tools"
	echo "[INFO]"
	cd wpan-tools
	./autogen.sh
	./configure
	make
	make install

	cd ..
fi
