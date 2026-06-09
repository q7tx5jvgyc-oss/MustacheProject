#include <ApplicationServices/ApplicationServices.h>
#include <unistd.h>
#include <iostream>
#include <thread>
#include <atomic>

// وظيفة لمحاكاة نقرة الماوس
extern "C" void click_mouse(int x, int y) {
    CGPoint point = CGPointMake(x, y);
    
    // حدث ضغط الزر الأيسر للماوس
    CGEventRef click_down = CGEventCreateMouseEvent(
        NULL, kCGMouseEventLeftDown,
        point,
        kCGMouseButtonLeft
    );
    
    // حدث إفلات الزر الأيسر للماوس
    CGEventRef click_up = CGEventCreateMouseEvent(
        NULL, kCGMouseEventLeftUp,
        point,
        kCGMouseButtonLeft
    );
    
    // إرسال الأحداث
    CGEventPost(kCGHIDEventTap, click_down);
    CGEventPost(kCGHIDEventTap, click_up);
    
    // تحرير الذاكرة
    CFRelease(click_down);
    CFRelease(click_up);
}

// وظيفة لبدء الأوتو كليكر بشكل مستمر
std::atomic<bool> running(false);

extern "C" void start_autoclicker(int x, int y, int interval_ms) {
    running = true;
    while (running) {
        click_mouse(x, y);
        usleep(interval_ms * 1000);
    }
}

extern "C" void stop_autoclicker() {
    running = false;
}

// وظيفة تهيئة اختيارية عند تحميل المكتبة
__attribute__((constructor))
static void custom_init() {
    // يمكن إضافة كود هنا يعمل بمجرد تحميل الـ dylib
}
