#! /bin/bash
echo 1 > /sys/bus/pci/devices/0000\:01\:00.0/remove
echo 1 > /sys/bus/pci/rescan
KERNEL_RELEASE=$(uname -r)
insmod /lib/modules/$KERNEL_RELEASE/avs_pci_xilinx_axi.ko
insmod  /lib/modules/$KERNEL_RELEASE/avs_ioctl_xilinx_axi.ko
#mknod /dev/xilinxAxi0 c 242 0
#mknod /dev/xilinxAxi1 c 242 1
#Above lines were hard coded and don't work in all cases
#Use gawk to extract the major device number from /proc/devices
MAJOR=`gawk "\\$2==\"xilinxAxiDrv\" {print \\$1}" /proc/devices`
rm -f /dev/xilinxAxi[0-1]
mknod /dev/xilinxAxi0 c $MAJOR 0
mknod /dev/xilinxAxi1 c $MAJOR 1
exit 0

