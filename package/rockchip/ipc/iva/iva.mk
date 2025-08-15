IVA_VERSION = rk3588-linux-6.1-rkr6
IVA_SITE = $(call github,mixtile-rockchip,mixtile-sdk-linux-ipc-media-iva,$(IVA_VERSION))
IVA_LICENSE = ROCKCHIP
IVA_LICENSE_FILES = LICENSE

IVA_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_IVA_RK3576),y)
IVA_CONF_OPTS += -DTARGET_SOC=rk3576
endif

ifeq ($(BR2_PACKAGE_IVA_RK3588),y)
IVA_CONF_OPTS += -DTARGET_SOC=rk3588
endif

ifeq ($(BR2_PACKAGE_IVA_RV1106),y)
IVA_CONF_OPTS += -DTARGET_SOC=rv1106
endif

$(eval $(cmake-package))
