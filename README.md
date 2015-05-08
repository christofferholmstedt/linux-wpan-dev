linux-wpan dev scripts for Raspberry Pi
=======================================
This repository includes my scripts for compiling linux kernel development
branch/repository "bluetooth-next" for Raspberry Pi.

### Best documentation is running code
The main goal with this repository is to maintain a few scripts that make the
process of compiling the latest working bluetooth-next kernel as easy as
possible, as well as configuring the Raspberry Pis when they boot up.

## Building the kernel and U-Boot
#### Scripts
*Prerequisites*:
  - "gcc-arm-linux-gnueabi" package from Ubuntu/Debian repository

If you don't know what Vagrant is nor care to learn you can just skip all
vagrant files and head straight for the "scripts" folder. All scripts are made
for Ubuntu and tested on Ubuntu Trusty Tahr 14.04.2.

	- download_prerequisites.sh
	Run this script first to clone (with git) both the bluetooth-next
	repository and the U-Boot repository from @swarren.

	- patch_and_build.sh
	Run this script as the second step to build the linux kernel and
	U-Boot. All artifacts will be put in the "output" folder ready to be
	copied to a microSD/SD card or made available over TFTP.

#### Vagrant
*Prerequisites*:
  - "gcc-arm-linux-gnueabi" package from Ubuntu/Debian repository
  - Virtualbox
  - Vagrant

In this git repository Vagrant is configured to boot up a Ubuntu 14.04 VM in
Virtualbox, update and upgrade as well as installing required build tools for
building the linux-kernel. The provisioning scripts do _not_ download nor
build/compile the linux-kernel or U-Boot. You have to do that yourself:

	1 vagrant up
	2 vagrant ssh
	3 ./host/scripts/download_prerequisites.sh
	4 ./host/scripts/patch_and_build.sh

## Configuring the device after boot-up
#### Scripts

## Release notes
##### v0.1.0
First release of scripts. This release was verified to work with
Raspberry Pi B the 8th of May 2015.

It uses bluetooth-next linux kernel from 2015-04-30 and U-Boot from 2015-11-10.
For wpan-tools version 0.4 is used.

## TODO (maybe, if I find it useful)
  * Update U-Boot to newer version.
  * Add support for Raspberry Pi Model B+
  * Add support for Raspberry Pi Model 2 Model B
  * Add support for BeagleBone Black
  * Add support for Raspberry Pi Model A+
	Need to pre-load with wpan-tools and configure it automatically on
	boot-up as ethernet is not available. If routing works over lowpan it
	might be possible to ssh over it. This practically means build a
	complete image for it.
