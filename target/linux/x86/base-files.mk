ifneq ($(TARGET_x86_generic_Soekris48xx)$(TARGET_x86_generic_Soekris45xx),)
define Package/base-files/install-target
	rm -f $(1)/etc/config/network
endef
endif

