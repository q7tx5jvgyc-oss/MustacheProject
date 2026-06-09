#import <UIKit/UIKit.h>

@interface AutoClickerWindow : UIWindow
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, assign) BOOL running;
@end

@implementation AutoClickerWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = 2000; // UIWindowLevelAlert + 1000
        self.backgroundColor = [UIColor clearColor];
        self.running = NO;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.panel = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 220, 250)];
    self.panel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.panel.layer.cornerRadius = 20;
    self.panel.layer.borderColor = [UIColor cyanColor].CGColor;
    self.panel.layer.borderWidth = 2;
    [self addSubview:self.panel];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 220, 30)];
    title.text = @"ULTRA CLICKER PRO";
    title.textColor = [UIColor cyanColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:14];
    [self.panel addSubview:title];

    self.btn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btn.frame = CGRectMake(20, 60, 180, 50);
    [self.btn setTitle:@"START ENGINE" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn.backgroundColor = [UIColor colorWithRed:0 green:0.7 blue:0.3 alpha:1];
    self.btn.layer.cornerRadius = 10;
    [self.btn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:self.btn];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.panel addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)p {
    CGPoint t = [p translationInView:self];
    p.view.center = CGPointMake(p.view.center.x + t.x, p.view.center.y + t.y);
    [p setTranslation:CGPointZero inView:self];
}

- (void)toggle {
    self.running = !self.running;
    if (self.running) {
        [self.btn setTitle:@"STOPPING..." forState:UIControlStateNormal];
        self.btn.backgroundColor = [UIColor redColor];
        [self startLoop];
    } else {
        [self.btn setTitle:@"START ENGINE" forState:UIControlStateNormal];
        self.btn.backgroundColor = [UIColor colorWithRed:0 green:0.7 blue:0.3 alpha:1];
    }
}

- (void)startLoop {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (self.running) {
            [NSThread sleepForTimeInterval:0.05];
        }
    });
}
@end

%ctor {
    dispatch_after(dispatch_time(0, 3 * 1000000000ull), dispatch_get_main_queue(), ^{
        AutoClickerWindow *win = [[AutoClickerWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [win makeKeyAndVisible];
    });
}
