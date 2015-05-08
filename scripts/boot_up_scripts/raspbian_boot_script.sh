#!/bin/bash
usage()
{
cat << EOF
    usage: $0 -a ADDRESS

    Example usage:
    -a 1 (fe80::1/64)
    -a cafe (fe80::cafe/64)
    -a 100 (fe80::100/64)

    OPTIONS:
    -h Shows this message
    -a Link-local IPv6 address. Last 16 bit in hexadecimal.
EOF
}

while getopts “ha:” OPTION
do
case $OPTION in
	h)
		usage
		exit 1
		;;
	a)
		ADDRESS=$OPTARG
		;;
	?)
		usage
		exit
		;;
	esac
done

if [[ -z $ADDRESS ]]
then
	usage
	exit 1
fi

#############################################
# Must run this script with sudo
#############################################

# wpan0 inteface must be down but should be so by default (assuming ifplugd is
# disabled as above).
# Specify PAN_ID
iwpan dev wpan0 set pan_id 0xcafe

# Set up lowpan interface
ip link add link wpan0 name lowpan0 type lowpan

# Set an easy to remember local ip if needed.
ip address add dev lowpan0 scope link fe80::$ADDRESS/64

# Bring the interfaces up
ifconfig wpan0 up
ifconfig lowpan0 up
