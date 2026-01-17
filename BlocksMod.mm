#import <UIKit/UIKit.h>

@interface BlocksMenu : UIView
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIButton *toggleBtn;
@end

@implementation BlocksMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // The Main 𝔅 Button (Square/Blocky)
        self.toggleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.toggleBtn.frame = CGRectMake(40, 40, 50, 50);
        self.toggleBtn.backgroundColor = [UIColor blackColor];
        self.toggleBtn.layer.borderColor = [UIColor redColor].CGColor;
        self.toggleBtn.layer.borderWidth = 3.0f; // Thick border for "Block" look
        [self.toggleBtn setTitle:@"𝔅" forState:UIControlStateNormal];
        [self.toggleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.toggleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.toggleBtn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.toggleBtn];
        
        // The Mod List (Hidden by default)
        self.container = [[UIView alloc] initWithFrame:CGRectMake(40, 100, 200, 250)];
        self.container.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
        self.container.layer.borderColor = [UIColor redColor].CGColor;
        self.container.layer.borderWidth = 2.0f;
        self.container.hidden = YES;
        [self addSubview:self.container];
        
        [self addMod:@"SPEED" y:10 cmd:":speed 100"];
        [self addMod:@"FLY" y:60 cmd:":fly"];
        [self addMod:@"NOCLIP" y:110 cmd:":noclip"];
    }
    return self;
}

- (void)addMod:(NSString *)name y:(int)y cmd:(NSString *)cmd {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(10, y, 180, 40)];
    b.backgroundColor = [UIColor redColor];
    [b setTitle:name forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:14];
    [self.container addSubview:b];
}

- (void)toggle {
    self.container.hidden = !self.container.hidden;
}

@end

// Injector
__attribute__((constructor))
static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        BlocksMenu *menu = [[BlocksMenu alloc] initWithFrame:win.bounds];
        [win addSubview:menu];
    });
}
