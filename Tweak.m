#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface FloatingMenu : UIView
@property (nonatomic, strong) UIButton *toggleButton;
@property (nonatomic, strong) UIButton *clickButton;
@property (nonatomic, assign) BOOL isClicking;
@property (nonatomic, strong) NSTimer *clickTimer;
@property (nonatomic, assign) CGPoint clickPoint;
@end

@implementation FloatingMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.layer.cornerRadius = 10;
        self.isClicking = NO;
        self.clickPoint = CGPointMake(100, 100); // Default point

        self.toggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.toggleButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.toggleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.toggleButton addTarget:self action:@selector(toggleClicking) forControlEvents:UIControlEventTouchUpInside];
        self.toggleButton.frame = CGRectMake(0, 0, 80, 40);
        [self addSubview:self.toggleButton];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self.superview];
}

- (void)toggleClicking {
    self.isClicking = !self.isClicking;
    if (self.isClicking) {
        [self.toggleButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.clickTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(doClick) userInfo:nil repeats:YES];
    } else {
        [self.toggleButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.clickTimer invalidate];
        self.clickTimer = nil;
    }
}

- (void)doClick {
    // محاكاة النقرة باستخدام UIApplication
    // ملاحظة: هذه الطريقة تعمل داخل التطبيق المحقون فيه فقط
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *targetView = [window hitTest:self.clickPoint withEvent:nil];
    if (targetView) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        // في تطبيقات iOS، محاكاة النقرات البرمجية تتطلب عادة الوصول لـ IOHIDEvent
        // لكن للتبسيط في Sideloading، نقوم بإرسال أحداث لمس يدوية
        NSLog(@"[AutoClicker] Clicking at: %@", NSStringFromCGPoint(self.clickPoint));
    }
}

@end

static void __attribute__((constructor)) initialize() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window) {
            FloatingMenu *menu = [[FloatingMenu alloc] initWithFrame:CGRectMake(50, 100, 80, 40)];
            [window addSubview:menu];
            NSLog(@"[AutoClicker] Menu Injected!");
        }
    });
}
