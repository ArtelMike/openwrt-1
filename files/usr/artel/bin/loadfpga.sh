#! /bin/bash

KERNEL_RELEASE=$(uname -r)
LKMDIR="/lib/modules/$KERNEL_RELEASE"

if [ -a $LKMDIR ]
then
echo "using LKM dir $LKMDIR"
else
echo "ERROR: did not find  LKM dir $LKMDIR"
exit -1
fi

IMAGEDIR="/lib/firmware"

echo "Search for FPGA bitstream to load in directory $IMAGEDIR"

if [ $# != 1 ]
then
echo "Usage $0 <filename>"
echo "Available Images in $IMAGEDIR"
cd $IMAGEDIR
ls
exit -1
else
FILE=$1
fi


IMAGE="$IMAGEDIR/$FILE"

if [ -a $IMAGE ]
then
echo " load avs_io.ko"
insmod  $LKMDIR/avs_io.ko
echo ""

echo "insmod $LKMDIR/avs_loadfpga.ko file=$IMAGE board=DLC4555 bWidth=2"
insmod $LKMDIR/avs_loadfpga.ko file=$FILE board=DLC4555 bWidth=2
echo "load $LKMDIR/avs_loadfpga.ko done"
else
echo "$0: FPGA bitstream $IMAGE not found."
ls $IMAGEDIR/*
fi
exit 0

