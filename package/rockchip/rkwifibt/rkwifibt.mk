################################################################################
#
# rkwifibt
#
################################################################################

RKWIFIBT_VERSION = rkwifibt
RKWIFIBT_SITE = $(call github,JeffyCN,mirrors,$(RKWIFIBT_VERSION))
RKWIFIBT_LICENSE = ROCKCHIP
RKWIFIBT_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_RKWIFIBT_STATIC),y)
RKWIFIBT_CFLAGS = $(TARGET_CFLAGS) -static
RKWIFIBT_LDFLAGS = $(TARGET_LDFLAGS) -static
endif

$(eval $(meson-package))
