ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = kgvn

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = aov_menu
aov_menu_FILES = Tweak.xm
aov_menu_CFLAGS = -fobjc-arc
aov_menu_FRAMEWORKS = UIKit Foundation
aov_menu_LDFLAGS = -undefined dynamic_lookup

include $(THEOS_MAKE_PATH)/tweak.mk