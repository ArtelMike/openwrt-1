/*
 * DO NOT MODIFY
 *
 * This file was generated by dtoc from a .dtb (device tree binary) file.
 */

#include <stdbool.h>
#include <linux/libfdt.h>
struct dtd_ns16550_serial {
	fdt32_t		clock_frequency;
	struct phandle_1_arg clocks[2];
	const char *	dma_names[2];
	fdt32_t		dmas[4];
	fdt32_t		interrupts[3];
	fdt32_t		pinctrl_0;
	const char *	pinctrl_names;
	fdt64_t		reg[2];
	fdt32_t		reg_io_width;
	fdt32_t		reg_shift;
};
struct dtd_regulator_fixed {
	fdt32_t		gpio[3];
	fdt32_t		pinctrl_0;
	const char *	pinctrl_names;
	fdt32_t		regulator_max_microvolt;
	fdt32_t		regulator_min_microvolt;
	const char *	regulator_name;
	fdt32_t		vin_supply;
};
struct dtd_rockchip_gpio_bank {
	struct phandle_1_arg clocks[1];
	bool		gpio_controller;
	bool		interrupt_controller;
	fdt32_t		interrupts[3];
	fdt64_t		reg[2];
};
struct dtd_rockchip_rk3288_dw_mshc {
	fdt32_t		bus_width;
	bool		cap_mmc_highspeed;
	bool		cap_sd_highspeed;
	struct phandle_1_arg clocks[4];
	bool		disable_wp;
	fdt32_t		fifo_depth;
	fdt32_t		interrupts[3];
	fdt32_t		max_frequency;
	fdt32_t		pinctrl_0[4];
	const char *	pinctrl_names;
	fdt64_t		reg[2];
	bool		u_boot_spl_fifo_mode;
	fdt32_t		vmmc_supply;
	fdt32_t		vqmmc_supply;
};
struct dtd_rockchip_rk3328_cru {
	fdt64_t		reg[2];
	fdt32_t		rockchip_grf;
};
struct dtd_rockchip_rk3328_dmc {
	fdt64_t		reg[12];
	fdt32_t		rockchip_sdram_params[196];
};
struct dtd_rockchip_rk3328_grf {
	fdt64_t		reg[2];
};
struct dtd_rockchip_rk3328_pinctrl {
	bool		ranges;
	fdt32_t		rockchip_grf;
};
