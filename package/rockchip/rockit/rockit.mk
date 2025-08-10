################################################################################
#
# rockit project
#
################################################################################

ROCKIT_VERSION = main
ROCKIT_SITE = $(call gitlab,rockchip_linux_sdk_6.1/linux,rockit,$(ROCKIT_VERSION))

ROCKIT_INSTALL_STAGING = YES

ifneq ($(BR2_PACKAGE_RK3308),)
ROCKIT_CONF_OPTS += -DRK3308=TRUE
endif

ifneq ($(BR2_PACKAGE_RK3506),)
ROCKIT_CONF_OPTS += -DRK3506=TRUE
endif

$(eval $(cmake-package))
