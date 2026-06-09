#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface AutoClickerWindow : UIWindow
@property (nonatomic, strong) UIView *mainPanel;
@property (nonatomic, strong) UISlider *speedSlider;
@property (nonatomic, strong) UIButton *startStopButton;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) float clickInterval;
@property (nonatomic, strong) NSMutableArray *targets;
@end

@implementation AutoClickerWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert + 100.0;
        self.backgroundColor = [UIColor clearColor];
        self.isRunning = NO;
        self.clickInterval = 0.05; 
        self.targets = [NSMutableArray array];
        [self setupMainPanel];
    }
    return self;
}

- (void)setupMainPanel {
    self.mainPanel = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 240, 280)];
    self.mainPanel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    self.mainPanel.layer.cornerRadius = 25;
    self.mainPanel.layer.borderWidth = 2.0;
    self.mainPanel.layer.borderColor = [UIColor cyanColor].CGColor;
    self.mainPanel.layer.shadowColor = [UIColor cyanColor].CGColor;
    self.mainPanel.layer.shadowRadius = 10;
    self.mainPanel.layer.shadowOpacity = 0.5;
    self.mainPanel.clipsToBounds = YES;
    [self addSubview:self.mainPanel];

    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 45)];
    header.text = @"◈ ULTRA AUTO CLICKER ◈";
    header.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.15];
    header.textColor = [UIColor cyanColor];
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont boldSystemFontOfSize:14];
    [self.mainPanel addSubview:header];

    UIButton *addBtn = [self createStyledButtonWithFrame:CGRectMake(15, 60, 100, 50) title:@"Add Point" color:[UIColor colorWithRed:0.0 green:0.4 blue:0.9 alpha:1.0]];
    [addBtn addTarget:self action:@selector(addTargetAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mainPanel addSubview:addBtn];

    UIButton *clearBtn = [self createStyledButtonWithFrame:CGRectMake(125, 60, 100, 50) title:@"Reset" color:[UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:1.0]];
    [clearBtn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mainPanel addSubview:clearBtn];

    self.startStopButton = [self createStyledButtonWithFrame:CGRectMake(15, 120, 210, 60) title:@"START ENGINE" color:[UIColor colorWithRed:0.0 green:0.8 blue:0.3 alpha:1.0]];
    [self.startStopButton addTarget:self action:@selector(toggleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mainPanel addSubview:self.startStopButton];

    UILabel *speedTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, 200, 20)];
    speedTitle.text = @"Turbo Speed Control";
    speedTitle.textColor = [UIColor whiteColor];
    speedTitle.font = [UIFont systemFontOfSize:12];
    [self.mainPanel addSubview:speedTitle];

    self.speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 215, 200, 30)];
    self.speedSlider.minimumValue = 0.001; 
    self.speedSlider.maximumValue = 0.5;
    self.speedSlider.value = 0.05;
    self.speedSlider.tintColor = [UIColor cyanColor];
    [self.speedSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.mainPanel addSubview:self.speedSlider];

    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 240, 20)];
    self.statusLabel.text = @"SYSTEM READY";
    self.statusLabel.textColor = [UIColor greenColor];
    self.statusLabel.font = [UIFont boldSystemFontOfSize:10];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.mainPanel addSubview:self.statusLabel];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.mainPanel addGestureRecognizer:pan];
}

- (UIButton *)createStyledButtonWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = color;
    btn.layer.cornerRadius = 12;
    return btn;
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
    [sender setTranslation:CGPointZero inView:self];
}

- (void)addTargetAction { self.statusLabel.text = @"TARGETING MODE ACTIVE"; }
- (void)clearAction { self.statusLabel.text = @"ALL TARGETS PURGED"; }
- (void)sliderChanged:(UISlider *)sender { self.clickInterval = sender.value; }

- (void)toggleAction {
    self.isRunning = !self.isRunning;
    if (self.isRunning) {
        [self.startStopButton setTitle:@"STOP ENGINE" forState:UIControlStateNormal];
        self.startStopButton.backgroundColor = [UIColor orangeColor];
        self.statusLabel.text = @"TURBO CLICKING ACTIVE";
        [self startHighSpeedLoop];
    } else {
        [self.startStopButton setTitle:@"START ENGINE" forState:UIControlStateNormal];
        self.startStopButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.3 alpha:1.0];
        self.statusLabel.text = @"SYSTEM IDLE";
    }
}

- (void)startHighSpeedLoop {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        while (self.isRunning) { [NSThread sleepForTimeInterval:self.clickInterval]; }
    });
}

@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AutoClickerWindow *ultraAC = [[AutoClickerWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [ultraAC makeKeyAndVisible];
    });
}
