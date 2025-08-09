################################################################################
#
# rockchip-alsa-config
#
################################################################################

ROCKCHIP_ALSA_CONFIG_VERSION = alsa-config
ROCKCHIP_ALSA_CONFIG_SITE = $(call github,JeffyCN,mirrors,$(ROCKCHIP_ALSA_CONFIG_VERSION))

ROCKCHIP_ALSA_CONFIG_LICENSE = Apache-2.0
ROCKCHIP_ALSA_CONFIG_LICENSE_FILES = NOTICE

$(eval $(meson-package))
