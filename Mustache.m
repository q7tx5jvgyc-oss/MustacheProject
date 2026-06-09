#import <UIKit/UIKit.h>

@interface MustacheMenu : NSObject
@property (nonatomic, strong) UIButton *bubble;
@property (nonatomic, strong) UIView *menuView;
@end

@implementation MustacheMenu

- (instancetype)init {
    self = [super init];
    if (self) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setupUI];
        });
    }
    return self;
}

- (void)setupUI {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // الأيقونة العائمة
    self.bubble = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bubble.frame = CGRectMake(100, 100, 60, 60);
    self.bubble.backgroundColor = [UIColor blackColor];
    [self.bubble setTitle:@"👨🏻‍💼" forState:UIControlStateNormal];
    self.bubble.layer.cornerRadius = 30;
    [self.bubble addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:self.bubble];
    
    // القائمة
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 300)];
    self.menuView.center = window.center;
    self.menuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.menuView.layer.cornerRadius = 20;
    self.menuView.hidden = YES;
    [window addSubview:self.menuView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 250, 30)];
    label.text = @"MUSTACHE CLICKER";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.menuView addSubview:label];
}

- (void)toggleMenu {
    self.menuView.hidden = !self.menuView.hidden;
}

@end

static void __attribute__((constructor)) initialize() {
    static MustacheMenu *menu;
    menu = [[MustacheMenu alloc] init];
}
