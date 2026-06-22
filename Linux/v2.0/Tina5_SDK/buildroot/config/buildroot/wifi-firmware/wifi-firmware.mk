################################################################################
#
# apps
#
################################################################################
WIFI_FIRMWARE_SITE_METHOD = local
WIFI_FIRMWARE_SITE = $(LICHEE_CBBPKG_DIR)/allwinner/wireless/firmware/$(wifi_name)
WIFI_FIRMWARE_LICENSE = GPLv2+, GPLv3+
WIFI_FIRMWARE_LICENSE_FILES = Copyright COPYING
FIRMWARE_DIR := $(LICHEE_BR_OUT)/target/lib/firmware
wifi_name=$(shell cat $(LICHEE_BR_OUT)/.config | grep "WIFI_NAME" | awk -F "\"" '{print $$2}')

define WIFI_FIRMWARE_INSTALL_TARGET_CMDS
	$(shell if [ ! -e $(FIRMWARE_DIR) ];then mkdir -p $(FIRMWARE_DIR); fi)
	$(shell cp -rf $(WIFI_FIRMWARE_SITE)/*  $(FIRMWARE_DIR))
endef

$(eval $(generic-package))
