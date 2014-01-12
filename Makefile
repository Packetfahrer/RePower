ARCHS = armv7 armv7s arm64

TARGET = iphone:clang:latest:5.0

THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = RePower
RePower_CFLAGS = -fobjc-arc
RePower_FILES = $(wildcard *.x) $(wildcard *.m)
RePower_FRAMEWORKS = Foundation UIKit QuartzCore
RePower_PRIVATE_FRAMEWORKS = TelephonyUI CoreGraphics


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += repower
include $(THEOS_MAKE_PATH)/aggregate.mk
