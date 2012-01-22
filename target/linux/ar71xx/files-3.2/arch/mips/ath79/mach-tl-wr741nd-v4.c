/*
 *  TP-LINK TL-WR741ND v4 board support
 *
 *  Copyright (C) 2011-2012 Gabor Juhos <juhosg@openwrt.org>
 *
 *  This program is free software; you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License version 2 as published
 *  by the Free Software Foundation.
 */

#include <linux/gpio.h>

#include <asm/mach-ath79/ath79.h>
#include <asm/mach-ath79/ar71xx_regs.h>

#include "common.h"
#include "dev-eth.h"
#include "dev-gpio-buttons.h"
#include "dev-leds-gpio.h"
#include "dev-m25p80.h"
#include "dev-wmac.h"
#include "machtypes.h"

#define TL_WR741NDV4_GPIO_BTN_RESET	11
#define TL_WR741NDV4_GPIO_BTN_WPS	26

#define TL_WR741NDV4_GPIO_LED_WLAN	0
#define TL_WR741NDV4_GPIO_LED_QSS	1
#define TL_WR741NDV4_GPIO_LED_WAN	13
#define TL_WR741NDV4_GPIO_LED_LAN1	14
#define TL_WR741NDV4_GPIO_LED_LAN2	15
#define TL_WR741NDV4_GPIO_LED_LAN3	16
#define TL_WR741NDV4_GPIO_LED_LAN4	17

#define TL_WR741NDV4_GPIO_LED_SYSTEM	27

#define TL_WR741NDV4_KEYS_POLL_INTERVAL	20	/* msecs */
#define TL_WR741NDV4_KEYS_DEBOUNCE_INTERVAL (3 * TL_WR741NDV4_KEYS_POLL_INTERVAL)

static const char *tl_wr741ndv4_part_probes[] = {
	"tp-link",
	NULL,
};

static struct flash_platform_data tl_wr741ndv4_flash_data = {
	.part_probes	= tl_wr741ndv4_part_probes,
};

static struct gpio_led tl_wr741ndv4_leds_gpio[] __initdata = {
	{
		.name		= "tp-link:green:lan1",
		.gpio		= TL_WR741NDV4_GPIO_LED_LAN1,
		.active_low	= 0,
	}, {
		.name		= "tp-link:green:lan2",
		.gpio		= TL_WR741NDV4_GPIO_LED_LAN2,
		.active_low	= 0,
	}, {
		.name		= "tp-link:green:lan3",
		.gpio		= TL_WR741NDV4_GPIO_LED_LAN3,
		.active_low	= 0,
	}, {
		.name		= "tp-link:green:lan4",
		.gpio		= TL_WR741NDV4_GPIO_LED_LAN4,
		.active_low	= 1,
	}, {
		.name		= "tp-link:green:qss",
		.gpio		= TL_WR741NDV4_GPIO_LED_QSS,
		.active_low	= 0,
	}, {
		.name		= "tp-link:green:system",
		.gpio		= TL_WR741NDV4_GPIO_LED_SYSTEM,
		.active_low	= 1,
	}, {
		.name		= "tp-link:green:wan",
		.gpio		= TL_WR741NDV4_GPIO_LED_WAN,
		.active_low	= 0,
	}, {
		.name		= "tp-link:green:wlan",
		.gpio		= TL_WR741NDV4_GPIO_LED_WLAN,
		.active_low	= 0,
	},
};

static struct gpio_keys_button tl_wr741ndv4_gpio_keys[] __initdata = {
	{
		.desc		= "reset",
		.type		= EV_KEY,
		.code		= KEY_RESTART,
		.debounce_interval = TL_WR741NDV4_KEYS_DEBOUNCE_INTERVAL,
		.gpio		= TL_WR741NDV4_GPIO_BTN_RESET,
		.active_low	= 1,
	}, {
		.desc		= "WPS",
		.type		= EV_KEY,
		.code		= KEY_WPS_BUTTON,
		.debounce_interval = TL_WR741NDV4_KEYS_DEBOUNCE_INTERVAL,
		.gpio		= TL_WR741NDV4_GPIO_BTN_WPS,
		.active_low	= 1,
	}
};

static void __init tl_wr741ndv4_gmac_setup(void)
{
	void __iomem *base;
	u32 t;

	base = ioremap(AR933X_GMAC_BASE, AR933X_GMAC_SIZE);

	t = __raw_readl(base + AR933X_GMAC_REG_ETH_CFG);
	t |= (AR933X_ETH_CFG_SW_PHY_SWAP | AR933X_ETH_CFG_SW_PHY_ADDR_SWAP);
	__raw_writel(t, base + AR933X_GMAC_REG_ETH_CFG);

	iounmap(base);
}

static void __init tl_wr741ndv4_setup(void)
{
	u8 *mac = (u8 *) KSEG1ADDR(0x1f01fc00);
	u8 *ee = (u8 *) KSEG1ADDR(0x1fff1000);

	tl_wr741ndv4_gmac_setup();

	ath79_gpio_function_disable(AR933X_GPIO_FUNC_ETH_SWITCH_LED0_EN |
				    AR933X_GPIO_FUNC_ETH_SWITCH_LED1_EN |
				    AR933X_GPIO_FUNC_ETH_SWITCH_LED2_EN |
				    AR933X_GPIO_FUNC_ETH_SWITCH_LED3_EN |
				    AR933X_GPIO_FUNC_ETH_SWITCH_LED4_EN);

	ath79_register_leds_gpio(-1, ARRAY_SIZE(tl_wr741ndv4_leds_gpio),
				 tl_wr741ndv4_leds_gpio);

	ath79_register_gpio_keys_polled(1, TL_WR741NDV4_KEYS_POLL_INTERVAL,
					ARRAY_SIZE(tl_wr741ndv4_gpio_keys),
					tl_wr741ndv4_gpio_keys);

	ath79_register_m25p80(&tl_wr741ndv4_flash_data);
	ath79_init_mac(ath79_eth0_data.mac_addr, mac, 1);
	ath79_init_mac(ath79_eth1_data.mac_addr, mac, -1);

	ath79_register_mdio(0, 0x0);
	ath79_register_eth(1);
	ath79_register_eth(0);

	ath79_register_wmac(ee, mac);
}

MIPS_MACHINE(ATH79_MACH_TL_WR741ND_V4, "TL-WR741ND-v4",
	     "TP-LINK TL-WR741ND v4", tl_wr741ndv4_setup);
