ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UltraAutoClicker
UltraAutoClicker_FILES = Tweak.xm
UltraAutoClicker_CFLAGS = -fobjc-arc
UltraAutoClicker_FRAMEWORKS = UIKit QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk
