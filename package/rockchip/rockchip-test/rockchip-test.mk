# add test tool for rockchip platform

ROCKCHIP_TEST_VERSION = linux-6.1-stan-rkr4.2
ROCKCHIP_TEST_SITE = $(call gitlab,rockchip_linux_sdk_6.1/linux,rockchip-test,$(ROCKCHIP_TEST_VERSION))
ROCKCHIP_TEST_LICENSE = ROCKCHIP
ROCKCHIP_TEST_LICENSE_FILES = LICENSE

define ROCKCHIP_TEST_INSTALL_TARGET_CMDS
	mkdir -p ${TARGET_DIR}/rockchip-test
	cp -rf  $(@D)/*  ${TARGET_DIR}/rockchip-test/
endef

define ROCKCHIP_TEST_INSTALL_INIT_SYSV
        $(INSTALL) -D -m 0755 $(@D)/auto_reboot/S99-auto-reboot \
		$(TARGET_DIR)/etc/init.d/
endef

define ROCKCHIP_TEST_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/auto_reboot/autoreboot.service \
		$(TARGET_DIR)/usr/lib/systemd/system/
endef

$(eval $(generic-package))
