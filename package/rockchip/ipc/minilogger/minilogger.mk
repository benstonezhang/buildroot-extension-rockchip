MINILOGGER_VERSION = rk3588-linux-6.1-rkr6
MINILOGGER_SITE = $(call github,mixtile-rockchip,mixtile-sdk-linux-external-minilogger,$(MINILOGGER_VERSION))
MINILOGGER_LICENSE = ROCKCHIP
MINILOGGER_LICENSE_FILES = LICENSE

MINILOGGER_INSTALL_STAGING = YES

MINILOGGER_DEPENDENCIES = libglib2 libunwind

$(eval $(cmake-package))
