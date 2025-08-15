AVS_VERSION = rk3588-linux-6.1-rkr6
AVS_SITE = $(call github,mixtile-rockchip,mixtile-sdk-linux-ipc-media-avs,$(AVS_VERSION))

AVS_INSTALL_STAGING = YES

AVS_CONF_OPTS += -DCONFIG_RK_AVS=ON

define AVS_INSTALL_TARGET_CMDS
	cp -rfp $(@D)/lib/*.so $(TARGET_DIR)/usr/lib/
	cp -rfp $(@D)/lib/*.so $(HOST_DIR)/aarch64-buildroot-linux-gnu/sysroot/usr/lib/
	cp -rfp $(@D)/lib/*.h $(HOST_DIR)/aarch64-buildroot-linux-gnu/sysroot/usr/include/
	cp -rfp $(@D)/avs_calib/ $(TARGET_DIR)/usr/share/
endef

$(eval $(generic-package))
