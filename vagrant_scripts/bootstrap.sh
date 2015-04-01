#!/bin/bash

#############################################
# Basic Ubuntu updating and upgrading
#############################################

###
# Changing to Swedish Ubuntu repository for faster downloads
###
ORIG_REPO="http://archive.ubuntu.com/ubuntu" # Ubuntu 14.04
NEW_REPO="http://se.archive.ubuntu.com/ubuntu"
sudo sed -i.orig "s|${ORIG_REPO}|${NEW_REPO}|g" /etc/apt/sources.list

###
# Update package list from new repository
###
sudo apt-get -y update

###
# Upgrade all packages to the latest version with dist-upgrade
# The longer more obscure command is to prevent all upgrades from
# asking any questions and waiting for response. Especially to prevent
# the upgrade of the package "grub-pc" from displaying the interactive
# menu asking for where to install the bootloader which will in worst
# case freeze your VM.
###
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o \
     Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
     dist-upgrade

###
# Remove packages not needed anymore.
###
sudo apt-get -y autoclean
sudo apt-get -y autoremove

#############################################
# Configuration of base Ubuntu installation
#############################################

###
# Enable ufw and allow SSH traffic.
###
sudo ufw allow ssh
sudo ufw --force enable
sudo ufw status verbose
