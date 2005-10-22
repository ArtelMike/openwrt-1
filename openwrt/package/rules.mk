# invoke ipkg with configuration in $(STAGING_DIR)/etc/ipkg.conf 

define PKG_template
IPKG_$(1):=$(PACKAGE_DIR)/$(2)_$(3)_$(4).ipk
IDIR_$(1):=$(PKG_BUILD_DIR)/ipkg/$(2)
INFO_$(1):=$(IPKG_STATE_DIR)/info/$(2).list

ifneq ($(BR2_PACKAGE_$(1)),)
compile-targets: $$(IPKG_$(1))
endif
ifneq ($(DEVELOPER),)
compile-targets: $$(IPKG_$(1))
endif
ifeq ($(BR2_PACKAGE_$(1)),y)
install-targets: $$(INFO_$(1))
endif

IDEPEND_$(1):=$$(strip $(5))

$$(IDIR_$(1))/CONTROL/control: $(PKG_BUILD_DIR)/.prepared
	$(SCRIPT_DIR)/make-ipkg-dir.sh $$(IDIR_$(1)) ./ipkg/$(2).control $(3) $(4)
	if [ "$$(IDEPEND_$(1))" != "" ]; then echo "Depends: $$(IDEPEND_$(1))" >> $$(IDIR_$(1))/CONTROL/control; fi
	for file in conffiles preinst postinst prerm postrm; do \
		[ -f ./ipkg/$(2).$$$$file ] && cp ./ipkg/$(2).$$$$file $$(IDIR_$(1))/CONTROL/$$$$file || true; \
	done

$$(IPKG_$(1)): $$(IDIR_$(1))/CONTROL/control $(PKG_BUILD_DIR)/.built $(PACKAGE_DIR)

$$(INFO_$(1)): $$(IPKG_$(1))
	$(IPKG) install $$(IPKG_$(1))

$(2)-clean:
	rm -f $$(IPKG_$(1))
clean: $(2)-clean
endef


ifneq ($(strip $(PKG_SOURCE)),)
$(DL_DIR)/$(PKG_SOURCE):
	@$(PKG_TRACE) Downloading...
	$(SCRIPT_DIR)/download.pl "$(DL_DIR)" "$(PKG_SOURCE)" "$(PKG_MD5SUM)" $(PKG_SOURCE_URL) $(MAKE_TRACE) 
endif

ifneq ($(strip $(PKG_CAT)),)
$(PKG_BUILD_DIR)/.prepared: $(DL_DIR)/$(PKG_SOURCE)
	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	$(PKG_CAT) $(DL_DIR)/$(PKG_SOURCE) | tar -C $(PKG_BUILD_DIR)/.. $(TAR_OPTIONS) -
	if [ -d ./patches ]; then \
		$(PATCH) $(PKG_BUILD_DIR) ./patches ; \
	fi
	touch $(PKG_BUILD_DIR)/.prepared
endif

all: compile

source: $(DL_DIR)/$(PKG_SOURCE)
prepare:
	@[ -f $(PKG_BUILD_DIR)/.prepared ] || { \
		$(PKG_TRACE) Preparing...; \
		$(MAKE) $(PKG_BUILD_DIR)/.prepared $(MAKE_TRACE); \
	}

configure:
	@[ -f $(PKG_BUILD_DIR)/.configured ] || { \
		$(PKG_TRACE) Configuring...; \
		$(MAKE) $(PKG_BUILD_DIR)/.configured $(MAKE_TRACE); \
	}

compile-targets:
compile:
	@[ -f $(PKG_BUILD_DIR)/.configured ] || { \
		$(PKG_TRACE) Configuring...; \
		$(MAKE) $(PKG_BUILD_DIR)/.configured $(MAKE_TRACE); \
	}
	@[ -f $(PKG_BUILD_DIR)/.built ] || { \
		$(PKG_TRACE) Compiling...; \
		$(MAKE) compile-targets $(MAKE_TRACE); \
	}

install-targets:
install:
	@$(PKG_TRACE) Installing...
	@$(MAKE) install-targets $(MAKE_TRACE)

mostlyclean:
rebuild:
	$(PKG_TRACE) Rebuilding...
	@-$(MAKE) mostlyclean 2>&1 >/dev/null
	if [ -f $(PKG_BUILD_DIR)/.built ]; then \
		$(MAKE) clean $(MAKE_TRACE); \
	fi
	$(MAKE) compile $(MAKE_TRACE)

$(PKG_BUILD_DIR)/.configured: prepare
$(PKG_BUILD_DIR)/.built: configure

$(PACKAGE_DIR):
	mkdir -p $@

clean-targets:
clean: 
	@$(PKG_TRACE) Cleaning...
	@$(MAKE) clean-targets $(MAKE_TRACE)
	rm -rf $(PKG_BUILD_DIR)

.PHONY: all source prepare compile install clean
