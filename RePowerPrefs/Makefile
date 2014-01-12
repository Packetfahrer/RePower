ARCHS = armv7 armv7s arm64
TARGET = iphone:clang:latest:5.0

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

BUNDLE_NAME = RePowerPrefs
RePowerPrefs_FILES = RePowerPrefs.xm $(wildcard *.m)
RePowerPrefs_INSTALL_PATH = /Library/PreferenceBundles
RePowerPrefs_FRAMEWORKS = Foundation UIKit CoreGraphics MessageUI
RePowerPrefs_PRIVATE_FRAMEWORKS = Preferences
RePowerPrefs_CFLAGS = -fobjc-arc

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/RePowerPrefs.plist$(ECHO_END)
