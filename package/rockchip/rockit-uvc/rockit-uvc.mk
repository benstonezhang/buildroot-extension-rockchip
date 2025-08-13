################################################################################
#
# rockit-uvc project
#
################################################################################

ROCKIT_UVC_VERSION = linux-6.1-stan-rkr4.2
ROCKIT_UVC_SITE = $(call gitlab,rockchip_linux_sdk_6.1/linux/external,rockit_uvc,$(ROCKIT_UVC_VERSION))

ROCKIT_UVC_INSTALL_STAGING = YES

ROCKIT_UVC_LICENSE = ROCKCHIP
ROCKIT_UVC_LICENSE_FILES = LICENSE

ROCKIT_UVC_DEPENDENCIES = rockit rockchip-uvc-app

$(eval $(cmake-package))
