#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id$

EMENU:=Other modules

define KernelPackage/crc-itu-t
  SUBMENU:=$(EMENU)
  TITLE:=CRC ITU-T V.41 support
  DESCRIPTION:=Kernel module for CRC ITU-T V.41 support
  KCONFIG:=CONFIG_CRC_ITU_T
  FILES:=$(LINUX_DIR)/lib/crc-itu-t.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,20,crc-itu-t)
endef

$(eval $(call KernelPackage,crc-itu-t))


define KernelPackage/crypto
  SUBMENU:=$(EMENU)
  TITLE:=CryptoAPI modules
  KCONFIG:= \
	CONFIG_CRYPTO_HMAC \
	CONFIG_CRYPTO_NULL \
	CONFIG_CRYPTO_MD4 \
	CONFIG_CRYPTO_MD5 \
	CONFIG_CRYPTO_SHA1 \
	CONFIG_CRYPTO_SHA256 \
	CONFIG_CRYPTO_SHA512 \
	CONFIG_CRYPTO_WP512 \
	CONFIG_CRYPTO_TGR192 \
	CONFIG_CRYPTO_DES \
	CONFIG_CRYPTO_BLOWFISH \
	CONFIG_CRYPTO_TWOFISH \
	CONFIG_CRYPTO_SERPENT \
	CONFIG_CRYPTO_AES \
	CONFIG_CRYPTO_CAST5 \
	CONFIG_CRYPTO_CAST6 \
	CONFIG_CRYPTO_TEA \
	CONFIG_CRYPTO_ARC4 \
	CONFIG_CRYPTO_KHAZAD \
	CONFIG_CRYPTO_ANUBIS \
	CONFIG_CRYPTO_DEFLATE \
	CONFIG_CRYPTO_MICHAEL_MIC \
	CONFIG_CRYPTO_CRC32C \
	CONFIG_CRYPTO_ECB \
	CONFIG_CRYPTO_BLKCIPHER 
  FILES:=$(LINUX_DIR)/crypto/*.$(LINUX_KMOD_SUFFIX)
endef

$(eval $(call KernelPackage,crypto))


define KernelPackage/eeprom-93cx6
  SUBMENU:=$(EMENU)
  TITLE:=EEPROM 93CX6 support
  DESCRIPTION:=Kernel module for EEPROM 93CX6 support
  DEPENDS:=@LINUX_2_6
  KCONFIG:=CONFIG_EEPROM_93CX6
  FILES:=$(LINUX_DIR)/drivers/misc/eeprom_93cx6.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,20,eeprom_93cx6)
endef

$(eval $(call KernelPackage,eeprom-93cx6))


define KernelPackage/lp
  SUBMENU:=$(EMENU)
  TITLE:=Parallel port and line printer support
  DEPENDS:=@LINUX_2_4
  KCONFIG:= \
	CONFIG_PARPORT \
	CONFIG_PRINTER \
	CONFIG_PPDEV
  FILES:= \
	$(LINUX_DIR)/drivers/parport/parport.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/char/lp.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/char/ppdev.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,parport lp)
endef

$(eval $(call KernelPackage,lp))


define KernelPackage/soundcore
  SUBMENU:=$(EMENU)
  TITLE:=Sound support
  KCONFIG:=CONFIG_SOUND
endef

define KernelPackage/soundcore/2.4
  FILES:=$(LINUX_DIR)/drivers/sound/soundcore.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,30,soundcore)
endef

define KernelPackage/soundcore/2.6
  KCONFIG+= \
	CONFIG_SND \
	CONFIG_SND_HWDEP \
	CONFIG_SND_RAWMIDI \
	CONFIG_SND_TIMER \
	CONFIG_SND_PCM
  FILES:= \
	$(LINUX_DIR)/sound/soundcore.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/sound/core/snd.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/sound/core/snd-page-alloc.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/sound/core/snd-hwdep.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/sound/core/snd-rawmidi.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/sound/core/snd-timer.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/sound/core/snd-pcm.$(LINUX_KMOD_SUFFIX) \
	$(if $(CONFIG_SND_MIXER_OSS),$(LINUX_DIR)/sound/core/oss/snd-mixer-oss.$(LINUX_KMOD_SUFFIX)) \
	$(if $(CONFIG_SND_PCM_OSS),$(LINUX_DIR)/sound/core/oss/snd-pcm-oss.$(LINUX_KMOD_SUFFIX))
  AUTOLOAD:=$(call AutoLoad,30, \
	soundcore \
	snd \
	snd-page-alloc \
	snd-hwdep \
	snd-rawmidi \
	snd-timer \
	snd-pcm \
	$(if $(CONFIG_SND_MIXER_OSS),snd-mixer-oss) \
	$(if $(CONFIG_SND_PCM_OSS),snd-pcm-oss) \
  )
endef

define KernelPackage/soundcore/uml-2.6
  KCONFIG+= \
	CONFIG_HOSTAUDIO
  FILES:= \
	$(LINUX_DIR)/sound/soundcore.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/arch/um/drivers/hostaudio.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,30,soundcore hostaudio)
endef

define KernelPackage/soundcore/description
 Kernel modules for sound support
endef

$(eval $(call KernelPackage,soundcore))


define KernelPackage/loop
  SUBMENU:=$(EMENU)
  TITLE:=Loopback device support
  KCONFIG:=CONFIG_BLK_DEV_LOOP
  FILES:=$(LINUX_DIR)/drivers/block/loop.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,30,loop)
endef

define KernelPackage/loop/description
 Kernel module for loopback device support
endef

$(eval $(call KernelPackage,loop))


define KernelPackage/nbd
  SUBMENU:=$(EMENU)
  TITLE:=Network block device support
  KCONFIG:=CONFIG_BLK_DEV_NBD
  FILES:=$(LINUX_DIR)/drivers/block/nbd.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,30,nbd)
endef

define KernelPackage/nbd/description
 Kernel module for network block device support
endef

$(eval $(call KernelPackage,nbd))


define KernelPackage/capi
  SUBMENU:=$(EMENU)
  TITLE:=CAPI Support
  DEPENDS:=@LINUX_2_6
  KCONFIG:= \
	CONFIG_ISDN \
	CONFIG_ISDN_CAPI \
	CONFIG_ISDN_CAPI_CAPI20
  FILES:= \
	$(LINUX_DIR)/drivers/isdn/capi/kernelcapi.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/isdn/capi/capi.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,30,kernelcapi capi)
endef

define KernelPackage/capi/description
 Kernel module for basic CAPI support
endef

$(eval $(call KernelPackage,capi))


define KernelPackage/pcmcia-core
  SUBMENU:=$(EMENU)
  TITLE:=PCMCIA/CardBus support
  DEPENDS:=@PCMCIA_SUPPORT
endef

define KernelPackage/pcmcia-core/2.4
  KCONFIG:= \
	CONFIG_PCMCIA \
	CONFIG_CARDBUS
  FILES:= \
	$(LINUX_DIR)/drivers/pcmcia/pcmcia_core.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/ds.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/yenta_socket.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,40,pcmcia_core yenta_socket ds)
endef

define KernelPackage/pcmcia-core/2.6
  KCONFIG:= \
	CONFIG_PCCARD \
	CONFIG_PCMCIA \
	CONFIG_YENTA \
	CONFIG_PCCARD_NONSTATIC \
	PCMCIA_DEBUG=n
  FILES:= \
	$(LINUX_DIR)/drivers/pcmcia/pcmcia_core.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/pcmcia.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/rsrc_nonstatic.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/yenta_socket.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,40,pcmcia_core pcmcia rsrc_nonstatic yenta_socket)
endef

define KernelPackage/pcmcia-core/au1000-2.6
  FILES:= \
	$(LINUX_DIR)/drivers/pcmcia/pcmcia_core.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/pcmcia.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/rsrc_nonstatic.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/au1x00_ss.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,40,pcmcia_core pcmcia rsrc_nonstatic au1x00_ss)
endef

define KernelPackage/pcmcia-core/description
 Kernel support for PCMCIA/CardBus controllers
endef

$(eval $(call KernelPackage,pcmcia-core))


define KernelPackage/pcmcia-serial
  SUBMENU:=$(EMENU)
  TITLE:=Serial devices support
  DEPENDS:=kmod-pcmcia-core
  AUTOLOAD:=$(call AutoLoad,45,serial_cs)
endef

define KernelPackage/pcmcia-serial/2.4
  KCONFIG:=CONFIG_PCMCIA_SERIAL_CS
  FILES:=$(LINUX_DIR)/drivers/char/pcmcia/serial_cs.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/pcmcia-serial/2.6
  KCONFIG:=CONFIG_SERIAL_8250_CS
  FILES:=$(LINUX_DIR)/drivers/serial/serial_cs.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/pcmcia-serial/description
 Kernel support for PCMCIA/CardBus serial devices
endef

$(eval $(call KernelPackage,pcmcia-serial))


define KernelPackage/bluetooth
  SUBMENU:=$(EMENU)
  TITLE:=Bluetooth support
  DEPENDS:=@USB_SUPPORT
endef

define KernelPackage/bluetooth/2.4
  KCONFIG:= \
	CONFIG_BLUEZ \
	CONFIG_BLUEZ_L2CAP \
	CONFIG_BLUEZ_SCO \
	CONFIG_BLUEZ_RFCOMM \
	CONFIG_BLUEZ_BNEP \
	CONFIG_BLUEZ_HCIUART \
	CONFIG_BLUEZ_HCIUSB
  FILES:= \
	$(LINUX_DIR)/net/bluetooth/bluez.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/l2cap.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/sco.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/rfcomm/rfcomm.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/bnep/bnep.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/bluetooth/hci_uart.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/bluetooth/hci_usb.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,90,bluez l2cap sco rfcomm bnep hci_uart hci_usb)
endef

define KernelPackage/bluetooth/2.6
  KCONFIG:= \
	CONFIG_BT \
	CONFIG_BT_L2CAP \
	CONFIG_BT_SCO \
	CONFIG_BT_RFCOMM \
	CONFIG_BT_BNEP \
	CONFIG_BT_HCIUSB \
	CONFIG_BT_HCIUART
  FILES:= \
	$(LINUX_DIR)/net/bluetooth/bluetooth.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/l2cap.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/sco.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/rfcomm/rfcomm.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/bnep/bnep.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/bluetooth/hci_uart.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/bluetooth/hci_usb.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,90,bluetooth l2cap sco rfcomm bnep hci_uart hci_usb)
endef

define KernelPackage/bluetooth/description
 Kernel support for Bluetooth devices
endef

$(eval $(call KernelPackage,bluetooth))


define KernelPackage/mmc
  SUBMENU:=$(EMENU)
  TITLE:=MMC/SD Card Support
  DEPENDS:=@LINUX_2_6_AT91
  KCONFIG:= \
	CONFIG_MMC \
	CONFIG_MMC_BLOCK \
	CONFIG_MMC_AT91
  FILES:= \
	$(LINUX_DIR)/drivers/mmc/mmc_core.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/mmc/mmc_block.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/mmc/at91_mci.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,90,mmc_core mmc_block at91_mci)
endef

define KernelPackage/mmc/description
 Kernel support for MMC/SD cards
endef

$(eval $(call KernelPackage,mmc))


define KernelPackage/softdog
  SUBMENU:=$(EMENU)
  TITLE:=Software watchdog driver
  KCONFIG:=CONFIG_SOFT_WATCHDOG
  AUTOLOAD:=$(call AutoLoad,50,softdog)
endef

define KernelPackage/softdog/2.4
  FILES:=$(LINUX_DIR)/drivers/char/softdog.o
endef

define KernelPackage/softdog/2.6
  FILES:=$(LINUX_DIR)/drivers/char/watchdog/softdog.ko
endef

define KernelPackage/softdog/description
 Software watchdog driver
endef

$(eval $(call KernelPackage,softdog))


define KernelPackage/videodev
  SUBMENU:=$(EMENU)
  TITLE=Video4Linux support
  KCONFIG:=CONFIG_VIDEO_DEV
endef

define KernelPackage/videodev/2.4
  FILES:=$(LINUX_DIR)/drivers/media/video/videodev.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,60,videodev)
endef

define KernelPackage/videodev/2.6
  FILES:= \
	$(LINUX_DIR)/drivers/media/video/v4l2-common.$(LINUX_KMOD_SUFFIX) \
	$(if $(CONFIG_VIDEO_V4L1_COMPAT),$(LINUX_DIR)/drivers/media/video/v4l1-compat.$(LINUX_KMOD_SUFFIX)) \
	$(LINUX_DIR)/drivers/media/video/compat_ioctl32.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/media/video/videodev.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,60, \
	v4l2-common \
	$(if $(CONFIG_VIDEO_V4L1_COMPAT),v4l1-compat) \
	compat_ioctl32 \
	videodev \
  )
endef

define KernelPackage/videodev/description
 Kernel modules for Video4Linux support
endef

$(eval $(call KernelPackage,videodev))


define KernelPackage/leds-net48xx
  SUBMENU:=$(EMENU)
  TITLE:=Soekris Net48xx LED support
  DEPENDS:=@LINUX_2_6_X86
  KCONFIG:=CONFIG_LEDS_NET48XX
  FILES:=$(LINUX_DIR)/drivers/leds/leds-net48xx.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,leds-net48xx)
endef

define KernelPackage/leds-net48xx/description
 Kernel module for Soekris Net48xx LEDs
endef

$(eval $(call KernelPackage,leds-net48xx))


define KernelPackage/nsc-gpio
  SUBMENU:=$(EMENU)
  TITLE:=Natsemi GPIO support
  DEPENDS:=@LINUX_2_6_X86
  KCONFIG:=CONFIG_NSC_GPIO
  FILES:=$(LINUX_DIR)/drivers/char/nsc_gpio.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,40,nsc_gpio)
endef

define KernelPackage/nsc-gpio/description
 Kernel module for Natsemi GPIO
endef

$(eval $(call KernelPackage,nsc-gpio))


define KernelPackage/scx200-gpio
  SUBMENU:=$(EMENU)
  TITLE:=Natsemi SCX200 GPIO support
  DEPENDS:=kmod-nsc-gpio @LINUX_2_6_X86
  KCONFIG:=CONFIG_SCx200_GPIO
  FILES:=$(LINUX_DIR)/drivers/char/scx200_gpio.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,scx200_gpio)
endef

define KernelPackage/scx200-gpio/description
 Kernel module for SCX200 GPIO
endef

$(eval $(call KernelPackage,scx200-gpio))


define KernelPackage/scx200-wdt
  SUBMENU:=$(EMENU)
  TITLE:=Natsemi SCX200 Watchdog support
  DEPENDS:=@LINUX_2_6_X86
  KCONFIG:=CONFIG_SC1200_WDT
  FILES:=$(LINUX_DIR)/drivers/char/watchdog/scx200_wdt.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,scx200_wdt)
endef

define KernelPackage/scx200-wdt/description
 Kernel module for SCX200 Watchdog
endef

$(eval $(call KernelPackage,scx200-wdt))


define KernelPackage/hwmon
  SUBMENU:=$(EMENU)
  TITLE:=Hardware monitoring support
  DEPENDS:=@LINUX_2_6
  KCONFIG:= \
	CONFIG_HWMON \
	CONFIG_HWMON_VID \
	CONFIG_HWMON_DEBUG_CHIP=n
  FILES:= \
	$(LINUX_DIR)/drivers/hwmon/hwmon.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/hwmon/hwmon-vid.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,40,hwmon hwmon-vid)
endef

define KernelPackage/hwmon/description
 Kernel modules for hardware monitoring
endef

$(eval $(call KernelPackage,hwmon))


define KernelPackage/hwmon-pc87360
  SUBMENU:=$(EMENU)
  TITLE:=PC87360 monitoring support
  DEPENDS:=kmod-hwmon
  KCONFIG:=CONFIG_SENSORS_PC87360
  FILES:=$(LINUX_DIR)/drivers/hwmon/pc87360.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,pc87360)
endef

define KernelPackage/hwmon-pc87360/description
 Kernel modules for PC87360 chips
endef

$(eval $(call KernelPackage,hwmon-pc87360))


define KernelPackage/input-core
  SUBMENU:=$(EMENU)
  TITLE:=Input device core
  DEPENDS:=@LINUX_2_6
  KCONFIG:=CONFIG_INPUT
  FILES:=$(LINUX_DIR)/drivers/input/input-core.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,input-core)
endef

define KernelPackage/input-core/description
 Kernel modules for support of input device
endef

$(eval $(call KernelPackage,input-core))


define KernelPackage/input-evdev
  SUBMENU:=$(EMENU)
  TITLE:=Input even device
  DEPENDS:=+kmod-input-core
  KCONFIG:=CONFIG_INPUT_EVDEV
  FILES:=$(LINUX_DIR)/drivers/input/evdev.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,60,evdev)
endef

define KernelPackage/input-evdev/description
 Kernel modules for support of input device events
endef

$(eval $(call KernelPackage,input-evdev))
