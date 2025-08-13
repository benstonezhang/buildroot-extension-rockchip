################################################################################
#
# rockchip_uac_app project
#
################################################################################

ROCKCHIP_UAC_APP_VERSION = linux-6.1-stan-rkr4
ROCKCHIP_UAC_APP_SITE = $(call gitlab,rockchip_linux_sdk_6.1/linux/external,uac_app,$(ROCKCHIP_UAC_APP_VERSION))

ROCKCHIP_UAC_APP_INSTALL_STAGING = YES

ROCKCHIP_UAC_APP_LICENSE = ROCKCHIP
ROCKCHIP_UAC_APP_LICENSE_FILES = LICENSE

ROCKCHIP_UAC_APP_DEPENDENCIES += rockit

ROCKCHIP_UAC_APP_CONF_OPTS += "-DUAC_BUILDROOT=ON"

$(eval $(generic-package))
