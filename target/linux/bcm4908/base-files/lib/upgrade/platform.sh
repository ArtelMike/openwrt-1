# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause

RAMFS_COPY_BIN="bcm4908img expr"

PART_NAME=firmware

BCM4908_FW_FORMAT=
BCM4908_FW_BOARD_ID=
BCM4908_FW_INT_IMG_FORMAT=

# $(1): file to read from
# $(2): offset in bytes
# $(3): length in bytes
get_content() {
	dd if="$1" skip=$2 bs=1 count=$3 2>/dev/null
}

# $(1): file to read from
# $(2): offset in bytes
get_hex_u32_be() {
	dd if="$1" skip=$2 bs=1 count=4 2>/dev/null | hexdump -v -e '1/1 "%02x"'
}

platform_expected_image() {
	local machine=$(board_name)

	case "$machine" in
		asus,gt-ac5300)			echo "asus GT-AC5300";;
		netgear,r8000p)			echo "chk U12H359T00_NETGEAR";;
		tplink,archer-c2300-v1)		echo "";;
	esac
}

platform_identify() {
	local magic
	local size

	magic=$(get_hex_u32_be "$1" 0)
	case "$magic" in
		2a23245e)
			local header_len=$((0x$(get_hex_u32_be "$1" 4)))
			local board_id_len=$(($header_len - 40))

			BCM4908_FW_FORMAT="chk"
			BCM4908_FW_BOARD_ID=$(dd if="$1" skip=40 bs=1 count=$board_id_len 2>/dev/null | hexdump -v -e '1/1 "%c"')
			BCM4908_FW_INT_IMG_FORMAT="bcm4908img"
			return
		;;
	esac

	size=$(wc -c "$1" | cut -d ' ' -f 1)

	magic=$(get_content "$1" $((size - 20 - 64 + 8)) 12)
	case "$magic" in
		GT-AC5300)
			local size=$(wc -c "$1" | cut -d ' ' -f 1)

			BCM4908_FW_FORMAT="asus"
			BCM4908_FW_BOARD_ID=$(get_content "$1" $((size - 20 - 64 + 8)) 12)
			BCM4908_FW_INT_IMG_FORMAT="bcm4908img"
			return
		;;
	esac

	# Detecting native format is a bit complex (it may start with CFE or
	# JFFS2) so just use bcm4908img instead of bash hacks.
	# Make it the last attempt as bcm4908img detects also vendor formats.
	bcm4908img info -i "$1" > /dev/null && {
		BCM4908_FW_FORMAT="bcm4908img"
		return
	}
}

platform_check_image() {
	[ "$#" -gt 1 ] && return 1

	local expected_image=$(platform_expected_image)
	local error=0

	platform_identify "$1"
	[ -z "$BCM4908_FW_FORMAT" ] && {
		echo "Invalid image type. Please use firmware specific for this device."
		notify_firmware_broken
		return 1
	}
	echo "Found $BCM4908_FW_FORMAT firmware for device ${BCM4908_FW_BOARD_ID:----}"

	local expected_image="$(platform_expected_image)"
	[ -n "$expected_image" -a -n "$BCM4908_FW_BOARD_ID" -a "$BCM4908_FW_FORMAT $BCM4908_FW_BOARD_ID" != "$expected_image" ] && {
		echo "Firmware doesn't match device ($expected_image)"
		error=1
	}

	case "$BCM4908_FW_FORMAT" in
		"bcm4908img")
			bcm4908img info -i "$1" > /dev/null || {
				echo "Failed to validate BCM4908 image" >&2
				notify_firmware_broken
				return 1
			}

			bcm4908img bootfs -i "$1" ls | grep -q "1-openwrt" || {
				# OpenWrt images have 1-openwrt dummy file in the bootfs.
				# Don't allow backup if it's missing
				notify_firmware_no_backup
			}
			;;
		*)
			case "$BCM4908_FW_INT_IMG_FORMAT" in
				"bcm4908img")
					bcm4908img info -i "$1" > /dev/null || {
						echo "Failed to validate BCM4908 image" >&2
						notify_firmware_broken
						return 1
					}

					bcm4908img bootfs -i "$1" ls | grep -q "1-openwrt" || {
						# OpenWrt images have 1-openwrt dummy file in the bootfs.
						# Don't allow backup if it's missing
						notify_firmware_no_backup
					}
					;;
			esac
			;;
	esac

	return $error
}

# $1: cferam index increment value
platform_calc_new_cferam() {
	local inc="$1"
	local dir="/tmp/sysupgrade-bcm4908"

	local mtd=$(find_mtd_part bootfs)
	[ -z "$mtd" ] && {
		echo "Failed to find bootfs partition" >&2
		return
	}

	rm -fR $dir
	mkdir -p $dir
	mount -t jffs2 -o ro $mtd $dir || {
		echo "Failed to mount bootfs partition $mtd" >&2
		rm -fr $dir
		return
	}

	local idx=$(ls $dir/cferam.??? | sed -n 's/.*cferam\.\(\d\d\d\)/\1/p')
	[ -z "$idx" ] && {
		echo "Failed to find cferam current index" >&2
		rm -fr $dir
		return
	}

	umount $dir
	rm -fr $dir

	idx=$(($(expr $idx + $inc) % 1000))

	echo $(printf "cferam.%03d" $idx)
}

platform_do_upgrade_ubi() {
	local dir="/tmp/sysupgrade-bcm4908"
	local inc=1

	# Verify new bootfs size
	local mtd_bootfs_size=$(grep "\"bootfs\"" /proc/mtd | sed "s/mtd[0-9]*:[ \t]*\([^ \t]*\).*/\1/")
	[ -z "$mtd_bootfs_size" ] && {
		echo "Unable to find \"bootfs\" partition size"
		return
	}
	mtd_bootfs_size=$((0x$mtd_bootfs_size))
	local img_bootfs_size=$(bcm4908img extract -i "$1" -t bootfs | wc -c)
	[ $img_bootfs_size -gt $mtd_bootfs_size ] && {
		echo "New bootfs doesn't fit MTD partition."
		return
	}

	# Find cferam name for new firmware
	# For UBI we always flash "firmware" so don't increase cferam index if
	# there is "fallback". That could result in cferam.999 & cferam.001
	[ -n "$(find_mtd_index backup)" -o -n "$(find_mtd_index fallback)" ] && inc=0
	local cferam=$(platform_calc_new_cferam $inc)
	[ -z "$cferam" ] && exit 1

	# Prepare new firmware
	bcm4908img bootfs -i "$1" mv cferam.000 $cferam || {
		echo "Failed to rename cferam.000 to $cferam" >&2
		exit 1
	}

	# Extract rootfs for further flashing
	rm -fr $dir
	mkdir -p $dir
	bcm4908img extract -i "$1" -t rootfs > $dir/root || {
		echo "Failed to extract rootfs" >&2
		rm -fr $dir
		exit 1
	}

	# Flash bootfs MTD partition with new one
	mtd erase bootfs || {
		echo "Failed to erase bootfs" >&2
		rm -fr $dir
		exit 1
	}
	bcm4908img extract -i "$1" -t bootfs | mtd write - bootfs || {
		echo "Failed to flash bootfs" >&2
		rm -fr $dir
		exit 1
	}

	nand_do_upgrade $dir/root
}

platform_do_upgrade() {
	platform_identify "$1"

	# Try NAND aware UBI upgrade for OpenWrt images
	case "$BCM4908_FW_FORMAT" in
		"bcm4908img")
			bcm4908img bootfs -i "$1" ls | grep -q "1-openwrt" && platform_do_upgrade_ubi "$1"
			;;
		*)
			case "$BCM4908_FW_INT_IMG_FORMAT" in
				"bcm4908img")
					bcm4908img bootfs -i "$1" ls | grep -q "1-openwrt" && platform_do_upgrade_ubi "$1"
					;;
				*)
					echo "NAND aware sysupgrade is unsupported for $BCM4908_FW_FORMAT format"
					;;
			esac
			;;
	esac

	# Above calls exit on success.
	# If we got here it isn't OpenWrt image or something went wrong.
	echo "Writing whole image to NAND flash. All erase counters will be lost."

	# Find cferam name for new firmware
	local cferam=$(platform_calc_new_cferam 1)
	[ -z "$cferam" ] && exit 1

	# Prepare new firmware
	bcm4908img bootfs -i "$1" mv cferam.000 $cferam || {
		echo "Failed to rename cferam.000 to $cferam" >&2
		exit 1
	}

	# Jush flash firmware partition as is
	[ -n "$(find_mtd_index backup)" ] && PART_NAME=backup
	[ -n "$(find_mtd_index fallback)" ] && PART_NAME=fallback
	mtd erase $PART_NAME
	default_do_upgrade "$1" "bcm4908img extract -t firmware"
}
