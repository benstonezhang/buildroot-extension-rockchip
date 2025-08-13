################################################################################
#
# rockchip-uvc-app project
#
################################################################################


ROCKCHIP_UVC_APP_VERSION = linux-6.1-stan-rkr4
ROCKCHIP_UVC_APP_SITE = $(call gitlab,rockchip_linux_sdk_6.1/linux/external,uvc_app,$(ROCKCHIP_UVC_APP_VERSION))

ROCKCHIP_UVC_APP_INSTALL_STAGING = YES

ROCKCHIP_UVC_APP_DEPENDENCIES = libdrm

ROCKCHIP_UVC_APP_LICENSE = ROCKCHIP
ROCKCHIP_UVC_APP_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_RK3588),y)
ROCKCHIP_UVC_APP_CONF_OPTS += "-DRK3588=ON"
else ifeq ($(BR2_PACKAGE_RK3576),y)
ROCKCHIP_UVC_APP_CONF_OPTS += "-DRK3576=ON"
endif

$(eval $(cmake-package))
