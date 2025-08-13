################################################################################
#
# libv4l-rkmpp
#
################################################################################

LIBV4L_RKMPP_VERSION = 1.8.0
LIBV4L_RKMPP_SITE = $(call github,JeffyCN,libv4l-rkmpp,$(LIBV4L_RKMPP_VERSION))
LIBV4L_RKMPP_AUTORECONF = YES

LIBV4L_RKMPP_LICENSE = LGPL-2.1
LIBV4L_RKMPP_LICENSE_FILES = COPYING

LIBV4L_RKMPP_DEPENDENCIES = libv4l rockchip-mpp

$(eval $(meson-package))
