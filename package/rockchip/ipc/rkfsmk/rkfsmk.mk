RKFSMK_VERSION = rk3588-linux-6.1-rkr6
RKFSMK_SITE = $(call github,mixtile-rockchip,mixtile-sdk-linux-rkfsmk,$(RKFSMK_VERSION))
RKFSMK_LICENSE = ROCKCHIP
RKFSMK_LICENSE_FILES = LICENSE

RKFSMK_INSTALL_STAGING = YES

$(eval $(cmake-package))
