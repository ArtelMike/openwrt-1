/*
 * Copyright 2006, Johannes Berg <johannes@sipsolutions.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

/* just for IFNAMSIZ */
#include <linux/if.h>
#include "ieee80211_led.h"

void ieee80211_led_rx(struct ieee80211_local *local)
{
	if (unlikely(!local->rx_led))
		return;
	if (local->rx_led_counter++ % 2 == 0)
		led_trigger_event(local->rx_led, LED_OFF);
	else
		led_trigger_event(local->rx_led, LED_FULL);
}

/* q is 1 if a packet was enqueued, 0 if it has been transmitted */
void ieee80211_led_tx(struct ieee80211_local *local, int q)
{
	if (unlikely(!local->tx_led))
		return;
	/* not sure how this is supposed to work ... */
	local->tx_led_counter += 2*q-1;
	if (local->tx_led_counter % 2 == 0)
		led_trigger_event(local->tx_led, LED_OFF);
	else
		led_trigger_event(local->tx_led, LED_FULL);
}

void ieee80211_led_init(struct ieee80211_local *local)
{
	local->rx_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
	if (!local->rx_led)
		return;
	snprintf(local->rx_led_name, sizeof(local->rx_led_name),
		 "wiphy%drx", local->hw.index);
	local->rx_led->name = local->rx_led_name;
	if (led_trigger_register(local->rx_led)) {
		kfree(local->rx_led);
		local->rx_led = NULL;
	}

	local->tx_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
	if (!local->tx_led)
		return;
	snprintf(local->tx_led_name, sizeof(local->tx_led_name),
		 "wiphy%dtx", local->hw.index);
	local->tx_led->name = local->tx_led_name;
	if (led_trigger_register(local->tx_led)) {
		kfree(local->tx_led);
		local->tx_led = NULL;
	}
}

void ieee80211_led_exit(struct ieee80211_local *local)
{
	if (local->tx_led) {
		led_trigger_unregister(local->tx_led);
		kfree(local->tx_led);
	}
	if (local->rx_led) {
		led_trigger_unregister(local->rx_led);
		kfree(local->rx_led);
	}
}

char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
{
	struct ieee80211_local *local = hw_to_local(hw);

	if (local->tx_led)
		return local->tx_led_name;
	return NULL;
}
EXPORT_SYMBOL(__ieee80211_get_tx_led_name);

char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
{
	struct ieee80211_local *local = hw_to_local(hw);

	if (local->rx_led)
		return local->rx_led_name;
	return NULL;
}
EXPORT_SYMBOL(__ieee80211_get_rx_led_name);
