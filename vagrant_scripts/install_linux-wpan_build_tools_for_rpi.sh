#!/bin/bash

#############################################
# Download, install and configure all tools
# required to cross-compile bluetooth-next
# kernel for Raspberry Pi.
#
# The goal is to automate the process of
# getting 6LoWPAN working on multiple
# Raspberry Pis.
#############################################

#############################################
# gcc-arm-linux-gnueabi
#############################################
cd $HOME
echo "[INFO]"
echo "[INFO] Install build tools"
echo "[INFO] Installing gcc-arm-linux-gnueabi"
echo "[INFO]"
sudo apt-get install -y gcc-arm-linux-gnueabi
