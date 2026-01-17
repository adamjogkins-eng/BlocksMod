#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

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

// Logic to write FastFlags
- (void)setFlag:(NSString *)k v:(id)v {
    NSString *p = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"ClientSettings"];
    NSString *f = [p stringByAppendingPathComponent:@"ClientAppSettings.json"];
    [[NSFileManager defaultManager] createDirectoryAtPath:p withIntermediateDirectories:YES attributes:nil error:nil];

    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    if ([[NSFileManager defaultManager] fileExistsAtPath:f]) {
        NSData *data = [NSData dataWithContentsOfFile:f];
        if (data) d = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] ?: [NSMutableDictionary dictionary];
    }
    d[k] = v;
    [[NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:nil] writeToFile:f atomically:YES];
}

- (void)addOpt:(NSString *)txt y:(CGFloat)y sel:(SEL)s {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 160, 30)];
    l.text = [txt uppercaseString];
    l.textColor = [UIColor whiteColor];
    l.font = [UIFont fontWithName:@"Courier-Bold" size:12];
    [self.menu addSubview:l];

    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(185, y, 0, 0)];
    sw.onTintColor = [UIColor systemPurpleColor];
    sw.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [sw addTarget:self action:s forControlEvents:UIControlEventValueChanged];
    [self.menu addSubview:sw];
}

- (void)setupUI {
    // Floating Button (𝔳)
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 55, 55)];
    self.btn.backgroundColor = [UIColor colorWithRed:0.3 green:0.0 blue:0.6 alpha:0.9];
    self.btn.layer.cornerRadius = 27.5;
    self.btn.layer.borderWidth = 1.5;
    self.btn.layer.borderColor = [UIColor purpleColor].CGColor;
    [self.btn setTitle:@"𝔳" forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:26 weight:UIFontWeightBold];
    [self.btn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    [self addSubview:self.btn];

    // Main Panel
    self.menu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 260, 380)];
    self.menu.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    self.menu.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.07 alpha:0.95];
    self.menu.layer.cornerRadius = 20;
    self.menu.layer.borderColor = [UIColor systemPurpleColor].CGColor;
    self.menu.layer.borderWidth = 2;
    self.menu.alpha = 0;
    self.menu.contentSize = CGSizeMake(260, 520);

    UILabel *h = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 260, 30)];
    h.text = @"VOIDSTRAP MOBILE";
    h.textAlignment = NSTextAlignmentCenter;
    h.textColor = [UIColor systemPurpleColor];
    h.font = [UIFont fontWithName:@"Courier-Bold" size:18];
    [self.menu addSubview:h];

    // --- 9 LAG REDUCTION SETTINGS ---
    [self addOpt:@"Unlock 999 FPS" y:60 sel:@selector(f1:)];
    [self addOpt:@"Disable Textures" y:100 sel:@selector(f2:)];
    [self addOpt:@"Kill Shadows" y:140 sel:@selector(f3:)];
    [self addOpt:@"Potato Quality" y:180 sel:@selector(f4:)];
    [self addOpt:@"No Post-Process" y:220 sel:@selector(f5:)];
    [self addOpt:@"No Grass/Deco" y:260 sel:@selector(f6:)];
    [self addOpt:@"Force Metal API" y:300 sel:@selector(f7:)];
    [self addOpt:@"Optimized UI" y:340 sel:@selector(f8:)];
    [self addOpt:@"Data Saver" y:380 sel:@selector(f9:)];

    UIButton *save = [UIButton buttonWithType:UIButtonTypeSystem];
    save.frame = CGRectMake(30, 430, 200, 40);
    save.backgroundColor = [UIColor systemPurpleColor];
    [save setTitle:@"APPLY & RESTART" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    save.layer.cornerRadius = 10;
    [save addTarget:self action:@selector(doExit) forControlEvents:UIControlEventTouchUpInside];
    [self.menu addSubview:save];

    [self addSubview:self.menu];
}

// Action Handlers
- (void)f1:(UISwitch *)s { [self setFlag:@"DFIntTaskSchedulerTargetFps" v:s.isOn ? @999 : @60]; }
- (void)f2:(UISwitch *)s { [self setFlag:@"DFFlagDebugDisableOptimizedTextureTarget" v:s.isOn ? @"True" : @"False"]; }
- (void)f3:(UISwitch *)s { [self setFlag:@"FIntRenderShadowIntensity" v:s.isOn ? @0 : @1]; }
- (void)f4:(UISwitch *)s { [self setFlag:@"FIntDebugForceRenderQuality" v:s.isOn ? @1 : @0]; }
- (void)f5:(UISwitch *)s { [self setFlag:@"FFlagDisablePostProcess" v:s.isOn ? @"True" : @"False"]; }
- (void)f6:(UISwitch *)s { [self setFlag:@"FIntRenderTerrainDecorationPath" v:s.isOn ? @0 : @1]; }
- (void)f7:(UISwitch *)s { [self setFlag:@"FFlagDebugForceMetal" v:s.isOn ? @"True" : @"False"]; }
- (void)f8:(UISwitch *)s { [self setFlag:@"FFlagDebugDisableGui" v:s.isOn ? @"True" : @"False"]; }
- (void)f9:(UISwitch *)s { [self setFlag:@"FIntNetworkMaxPort" v:s.isOn ? @1 : @0]; }

- (void)toggle { [UIView animateWithDuration:0.2 animations:^{ self.menu.alpha = (self.menu.alpha == 0) ? 1 : 0; }]; }
- (void)pan:(UIPanGestureRecognizer *)p { self.btn.center = [p locationInView:self]; }
- (void)doExit { exit(0); }

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    return (v == self) ? nil : v;
}
@end

// MODERN CONSTRUCTOR (Fixes Deprecation)
__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject;
                break;
            }
        }
        if (!window) window = [UIApplication sharedApplication].windows.firstObject;
        
        VoidstrapMenu *v = [[VoidstrapMenu alloc] initWithFrame:window.bounds];
        v.layer.zPosition = 9999;
        [window addSubview:v];
    });
}
