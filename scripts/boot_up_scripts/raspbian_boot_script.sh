#!/bin/bash
usage()
{
cat << EOF

    usage: $0 -a ADDRESS -p PAN_ID

    Example usage:
    -a 1 -p cafe	(pan_id: 0xcafe and address: fe80::1/64)
    -a cafe -p cafe	(pan_id: 0xcafe and address: fe80::cafe/64)
    -a 100 -p ace	(pan_id: 0x0ace and address: fe80::100/64)

    OPTIONS:
    -h Shows this message
    -a Link-local IPv6 address. Last 16 bit in hexadecimal.
    -p 802.15.4 PAN ID. 16 bit in hexadecimal.
EOF
}

while getopts “ha:p:” OPTION
do
case $OPTION in
	h)
		usage
		exit 1
		;;
	a)
		ADDRESS=$OPTARG
		;;
	p)
		PANID=$OPTARG
		;;
	?)
		usage
		exit
		;;
	esac
done

if [[ -z $ADDRESS ]] || [[ -z $PANID ]]
then
	usage
	exit 1
fi

#############################################
# Must run this script with sudo
#############################################

# wpan0 inteface must be down
ifconfig wpan0 down
ifconfig lowpan0 down

# Specify PAN_ID
iwpan dev wpan0 set pan_id 0x$PANID

# Set up lowpan interface if it is not already set up.
if [[ ! -n $(ifconfig -a) ]]; then
	ip link add link wpan0 name lowpan0 type lowpan
fi

# Set an easy to remember local ip if needed
ip address add dev lowpan0 scope link fe80::$ADDRESS/64

# Bring the interfaces up
ifconfig wpan0 up
ifconfig lowpan0 up
