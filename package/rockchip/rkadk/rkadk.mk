################################################################################
#
# rkadk project
#
################################################################################

RKADK_VERSION = main
RKADK_SITE = $(call gitlab,rockchip_linux_sdk_6.1/linux/bsp,rkadk,$(RKADK_VERSION))

RKADK_INSTALL_STAGING = YES

define RKADK_LINK_GIT
    rm -rf $(@D)/.git
    ln -s $(SRCDIR)/.git $(@D)/
endef

RKADK_POST_RSYNC_HOOKS += RKADK_LINK_GIT

ifneq ($(BR2_PACKAGE_RK3506)$(BR2_PACKAGE_RK3308),)
RKADK_DEPENDENCIES += rockit common_algorithm
RKADK_CONF_OPTS += "-DRKADK_CHIP=rk3506"
RKADK_CONF_OPTS += "-DENABLE_STORAGE=OFF"
RKADK_CONF_OPTS += "-DUSE_RKAIQ=OFF"
endif

$(eval $(cmake-package))
