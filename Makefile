TARGET = :clang
ARCHS = armv7 armv7s arm64
THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = RePower
RePower_FILES = RePower.xm $(wildcard Headers/*.m)
RePower_FRAMEWORKS = Foundation UIKit QuartzCore
RePower_PRIVATE_FRAMEWORKS = TelephonyUI CoreGraphics
RePower_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += RePowerPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 backboardd"