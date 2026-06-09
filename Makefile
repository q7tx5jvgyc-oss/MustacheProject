INSTALL_TARGET_PROCESSES = YallaLudo
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = UltraAutoClicker
UltraAutoClicker_FILES = Tweak.xm
UltraAutoClicker_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk
