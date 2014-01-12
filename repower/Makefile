ARCHS = armv7 armv7s arm64

TARGET = iphone:clang:latest:5.0

include theos/makefiles/common.mk

BUNDLE_NAME = RePower
RePower_CFLAGS = -fobjc-arc
RePower_FILES = $(wildcard *.m)
RePower_INSTALL_PATH = /Library/PreferenceBundles
RePower_FRAMEWORKS = Foundation UIKit CoreGraphics MessageUI
RePower_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/*.plist$(ECHO_END)
