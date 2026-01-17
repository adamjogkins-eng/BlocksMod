#import <UIKit/UIKit.h>

@interface VoidstrapMenu : UIView
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIScrollView *menu;
@end

@implementation VoidstrapMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        [self setupUI];
    }
    return self;
}

- (void)setFlag:(NSString *)k v:(id)v {
    NSString *p = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"ClientSettings"];
    NSString *f = [p stringByAppendingPathComponent:@"ClientAppSettings.json"];
    [[NSFileManager defaultManager] createDirectoryAtPath:p withIntermediateDirectories:YES attributes:nil error:nil];

    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    if ([[NSFileManager defaultManager] fileExistsAtPath:f]) {
        d = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:f] options:NSJSONReadingMutableContainers error:nil] ?: [NSMutableDictionary dictionary];
    }
    d[k] = v;
    [[NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:nil] writeToFile:f atomically:YES];
}

- (void)addOpt:(NSString *)txt y:(CGFloat)y sel:(SEL)s {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 160, 30)];
    l.text = txt; l.textColor = [UIColor whiteColor]; l.font = [UIFont boldSystemFontOfSize:12];
    [self.menu addSubview:l];
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(190, y, 0, 0)];
    sw.onTintColor = [UIColor systemPurpleColor]; sw.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [sw addTarget:self action:s forControlEvents:UIControlEventValueChanged];
    [self.menu addSubview:sw];
}

- (void)setupUI {
    // Floating Button (𝔳)
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(40, 100, 50, 50)];
    self.btn.backgroundColor = [UIColor colorWithRed:0.4 green:0.0 blue:0.8 alpha:0.8];
    self.btn.layer.cornerRadius = 25;
    self.btn.layer.borderWidth = 2;
    self.btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btn setTitle:@"𝔳" forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    [self.btn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    [self addSubview:self.btn];

    // Menu Panel
    self.menu = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,260,340)];
    self.menu.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    self.menu.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    self.menu.layer.cornerRadius = 15;
    self.menu.layer.borderColor = [UIColor systemPurpleColor].CGColor;
    self.menu.layer.borderWidth = 2;
    self.menu.alpha = 0;
    self.menu.contentSize = CGSizeMake(260, 450);

    // Header
    UILabel *h = [[UILabel alloc] initWithFrame:CGRectMake(0,10,260,30)];
    h.text = @"VOIDSTRAP MOBILE V2"; h.textAlignment = NSTextAlignmentCenter;
    h.textColor = [UIColor systemPurpleColor]; h.font = [UIFont boldSystemFontOfSize:16];
    [self.menu addSubview:h];

    // 9 LAG REDUCTION SETTINGS
    [self addOpt:@"999 FPS UNLOCK" y:50 sel:@selector(f1:)];
    [self addOpt:@"REMOVE TEXTURES" y:85 sel:@selector(f2:)];
    [self addOpt:@"DISABLE SHADOWS" y:120 sel:@selector(f3:)];
    [self addOpt:@"LOW RENDER QUALITY" y:155 sel:@selector(f4:)];
    [self addOpt:@"DISABLE POST-PROC" y:190 sel:@selector(f5:)];
    [self addOpt:@"REMOVE DECO" y:225 sel:@selector(f6:)];
    [self addOpt:@"OPTIMIZE MEMORY" y:260 sel:@selector(f7:)];
    [self addOpt:@"MINIMUM BARS" y:295 sel:@selector(f8:)];
    [self addOpt:@"GPU ACCEL" y:330 sel:@selector(f9:)];

    UIButton *k = [UIButton buttonWithType:UIButtonTypeSystem];
    k.frame = CGRectMake(30, 380, 200, 35); k.backgroundColor = [UIColor systemPurpleColor];
    [k setTitle:@"SAVE & RESTART" forState:UIControlStateNormal]; [k setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    k.layer.cornerRadius = 10; [k addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.menu addSubview:k];

    [self addSubview:self.menu];
}

// FLAG LOGIC
- (void)f1:(UISwitch *)s { [self setFlag:@"DFIntTaskSchedulerTargetFps" v:s.isOn ? @999 : @60]; }
- (void)f2:(UISwitch *)s { [self setFlag:@"DFFlagDebugDisableOptimizedTextureTarget" v:s.isOn ? @"True" : @"False"]; }
- (void)f3:(UISwitch *)s { [self setFlag:@"FIntRenderShadowIntensity" v:s.isOn ? @0 : @1]; }
- (void)f4:(UISwitch *)s { [self setFlag:@"FIntDebugForceRenderQuality" v:s.isOn ? @1 : @0]; }
- (void)f5:(UISwitch *)s { [self setFlag:@"FFlagDisablePostProcess" v:s.isOn ? @"True" : @"False"]; }
- (void)f6:(UISwitch *)s { [self setFlag:@"FIntRenderTerrainDecorationPath" v:s.isOn ? @0 : @1]; }
- (void)f7:(UISwitch *)s { [self setFlag:@"FIntDebugForceGC" v:s.isOn ? @1 : @0]; }
- (void)f8:(UISwitch *)s { [self setFlag:@"FFlagDebugDisableGui" v:s.isOn ? @"True" : @"False"]; }
- (void)f9:(UISwitch *)s { [self setFlag:@"FFlagDebugForceMetal" v:s.isOn ? @"True" : @"False"]; }

- (void)toggle { [UIView animateWithDuration:0.2 animations:^{ self.menu.alpha = (self.menu.alpha == 0) ? 1 : 0; }]; }
- (void)pan:(UIPanGestureRecognizer *)p { self.btn.center = [p locationInView:self]; }
- (void)exit { exit(0); }
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    return (v == self) ? nil : v;
}
@end

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *w = [UIApplication sharedApplication].keyWindow ?: [UIApplication sharedApplication].windows.firstObject;
        VoidstrapMenu *m = [[VoidstrapMenu alloc] initWithFrame:w.bounds];
        m.layer.zPosition = 9999; // Force to front
        [w addSubview:m];
    });
}
