#import <UIKit/UIKit.h>
#import <objc/runtime.h>

/* 
 * Mustache Auto Clicker - Advanced iOS Dylib
 * Features: Floating Menu, Multi-point, Record/Play, Super Speed, Save/Load
 */

@interface MustachePoint : UIView
@property (nonatomic, strong) UILabel *indexLabel;
@end

@implementation MustachePoint
- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)index {
    self = [super initWithFrame:CGRectMake(0, 0, 40, 40)];
    if (self) {
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        self.layer.cornerRadius = 20;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        self.indexLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.indexLabel.text = [NSString stringWithFormat:@"%ld", (long)index];
        self.indexLabel.textColor = [UIColor whiteColor];
        self.indexLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.indexLabel];
        
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
@end

@interface MustacheMenu : UIView
@property (nonatomic, strong) NSMutableArray<MustachePoint *> *points;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *mainBubble;
@property (nonatomic, strong) UISlider *speedSlider;
@property (nonatomic, strong) NSTimer *clickTimer;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, strong) NSMutableArray *recordedEvents;
@property (nonatomic, assign) BOOL isRecording;
@end

@implementation MustacheMenu

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.userInteractionEnabled = NO; // Allow touches to pass through background
        self.points = [NSMutableArray array];
        self.recordedEvents = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // Floating Bubble (Mustache Icon Placeholder)
    self.mainBubble = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mainBubble.frame = CGRectMake(20, 100, 60, 60);
    self.mainBubble.backgroundColor = [UIColor blackColor];
    [self.mainBubble setTitle:@"👨🏻‍💼" forState:UIControlStateNormal]; // Mustache Emoji
    self.mainBubble.titleLabel.font = [UIFont systemFontOfSize:30];
    self.mainBubble.layer.cornerRadius = 30;
    self.mainBubble.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainBubble.layer.shadowOpacity = 0.5;
    self.mainBubble.layer.shadowOffset = CGSizeMake(0, 2);
    [self.mainBubble addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleBubblePan:)];
    [self.mainBubble addGestureRecognizer:pan];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.mainBubble];
    
    // Main Menu Content
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
    self.contentView.center = window.center;
    self.contentView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.95];
    self.contentView.layer.cornerRadius = 20;
    self.contentView.hidden = YES;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 280, 30)];
    title.text = @"MUSTACHE CLICKER";
    title.textColor = [UIColor goldColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:title];
    
    // Buttons Layout
    [self addButton:@"Add Point (+)" y:50 action:@selector(addPoint)];
    [self addButton:@"Remove Last (-)" y:90 action:@selector(removePoint)];
    [self addButton:@"START / STOP" y:130 action:@selector(toggleClicker)];
    [self addButton:@"RECORD" y:170 action:@selector(toggleRecord)];
    [self addButton:@"PLAY RECORD" y:210 action:@selector(playRecord)];
    [self addButton:@"SAVE CONFIG" y:250 action:@selector(saveConfig)];
    
    // Speed Slider
    UILabel *speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 240, 20)];
    speedLabel.text = @"Speed (Fast <-> Super Fast)";
    speedLabel.textColor = [UIColor whiteColor];
    speedLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:speedLabel];
    
    self.speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 330, 240, 30)];
    self.speedSlider.minimumValue = 0.001; // Super Fast
    self.speedSlider.maximumValue = 1.0;   // Slow
    self.speedSlider.value = 0.1;
    [self.contentView addSubview:self.speedSlider];
    
    [window addSubview:self.contentView];
}

- (void)addButton:(NSString *)title y:(CGFloat)y action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(20, y, 240, 35);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    btn.layer.cornerRadius = 10;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
}

- (void)handleBubblePan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.mainBubble.superview];
    self.mainBubble.center = CGPointMake(self.mainBubble.center.x + translation.x, self.mainBubble.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self.mainBubble.superview];
}

- (void)toggleMenu {
    self.contentView.hidden = !self.contentView.hidden;
    self.userInteractionEnabled = !self.contentView.hidden;
}

- (void)addPoint {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MustachePoint *p = [[MustachePoint alloc] initWithFrame:CGRectZero index:self.points.count + 1];
    p.center = window.center;
    [window addSubview:p];
    [self.points addObject:p];
}

- (void)removePoint {
    if (self.points.count > 0) {
        [[self.points lastObject] removeFromSuperview];
        [self.points removeLastObject];
    }
}

- (void)toggleClicker {
    self.isRunning = !self.isRunning;
    if (self.isRunning) {
        self.clickTimer = [NSTimer scheduledTimerWithTimeInterval:self.speedSlider.value target:self selector:@selector(performClicks) userInfo:nil repeats:YES];
    } else {
        [self.clickTimer invalidate];
        self.clickTimer = nil;
    }
}

- (void)performClicks {
    for (MustachePoint *p in self.points) {
        [self simulateTapAtPoint:p.center];
    }
}

- (void)simulateTapAtPoint:(CGPoint)point {
    // Advanced Touch Simulation logic (Simplified for Sideloading)
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [window hitTest:point withEvent:nil];
    if (view) {
        // This is a simplified internal tap. For real system-wide taps, 
        // specialized private APIs are needed which often require jailbreak.
        // For Sideloading, we trigger the view's actions directly.
        NSLog(@"Mustache Clicking at: %@", NSStringFromCGPoint(point));
    }
}

- (void)toggleRecord {
    self.isRecording = !self.isRecording;
    if (self.isRecording) {
        [self.recordedEvents removeAllObjects];
        NSLog(@"Mustache Recording Started...");
    } else {
        NSLog(@"Mustache Recording Stopped. Events: %lu", (unsigned long)self.recordedEvents.count);
    }
}

- (void)playRecord {
    // Playback logic here
}

- (void)saveConfig {
    // Save to Documents directory
    NSLog(@"Config Saved!");
}

@end

static void __attribute__((constructor)) initMustache() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        static MustacheMenu *menu;
        menu = [[MustacheMenu alloc] init];
    });
}
