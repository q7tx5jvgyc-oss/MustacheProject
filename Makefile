# إعدادات الهدف
TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = YallaLudo

# مسار Theos الافتراضي
THEOS_DEVICE_IP = localhost

include <LaTex>$(THEOS)/makefiles/common.mk

TWEAK_NAME = UltraAutoClicker

UltraAutoClicker_FILES = Tweak.xm
UltraAutoClicker_CFLAGS = -fobjc-arc
UltraAutoClicker_FRAMEWORKS = UIKit QuartzCore

include $</LaTex>(THEOS_MAKE_PATH)/tweak.mk
