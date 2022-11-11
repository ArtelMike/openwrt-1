#!/bin/sh

AVSPATH=/usr/artel/bin

$AVSPATH/prog5338
bash $AVSPATH/loadfpga.sh avsOGLoadLink
bash $AVSPATH/loadaxi.sh
exit 0

