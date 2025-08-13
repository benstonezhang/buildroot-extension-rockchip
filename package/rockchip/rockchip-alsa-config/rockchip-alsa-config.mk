################################################################################
#
# rockchip-alsa-config
#
################################################################################

#ROCKCHIP_ALSA_CONFIG_VERSION = alsa-config
#ROCKCHIP_ALSA_CONFIG_SITE = $(call github,JeffyCN,mirrors,$(ROCKCHIP_ALSA_CONFIG_VERSION))
ROCKCHIP_ALSA_CONFIG_VERSION = linux-6.1-stan-rkr4.2
ROCKCHIP_ALSA_CONFIG_SITE = $(call gitlab,rockchip_linux_sdk_6.1/linux/external,alsa-config,$(ROCKCHIP_ALSA_CONFIG_VERSION))

ROCKCHIP_ALSA_CONFIG_LICENSE = Apache-2.0
ROCKCHIP_ALSA_CONFIG_LICENSE_FILES = NOTICE

ifeq ($(BR2_ROCKCHIP_ALSA_CONFIG_INSTALL_INIT_SCRIPT),y)
ROCKCHIP_ALSA_CONFIG_CONF_OPTS += -Dinit_script=enabled
endif

$(eval $(meson-package))
