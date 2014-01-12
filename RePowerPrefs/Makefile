TARGET=:clang
ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = RePowerPrefs
RePowerPrefs_FILES = RePowerPrefs.xm
RePowerPrefs_INSTALL_PATH = /Library/PreferenceBundles
RePowerPrefs_FRAMEWORKS = Foundation UIKit CoreGraphics MessageUI
RePowerPrefs_PRIVATE_FRAMEWORKS = Preferences
RePowerPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/RePowerPrefs.plist$(ECHO_END)
