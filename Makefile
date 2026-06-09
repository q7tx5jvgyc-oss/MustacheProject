TARGET := iphone:clang:latest:14.5
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UltraAutoClicker
UltraAutoClicker_FILES = Tweak.xm
UltraAutoClicker_CFLAGS = -fobjc-arc
UltraAutoClicker_FRAMEWORKS = UIKit QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk
