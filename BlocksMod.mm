#import <UIKit/UIKit.h>
#import <objc/runtime.h> // <--- THIS FIXES YOUR ERRORS

@interface BlocksMenu : UIView
@property (nonatomic, strong) UIScrollView *consoleView;
@property (nonatomic, strong) UIButton *circleBtn;
@end

@implementation BlocksMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 1. THE CIRCLE BUTTON (Stylish 𝔅)
        self.circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.circleBtn.frame = CGRectMake(40, 100, 60, 60);
        self.circleBtn.backgroundColor = [UIColor blackColor];
        self.circleBtn.layer.cornerRadius = 30.0f;
        self.circleBtn.layer.borderColor = [UIColor redColor].CGColor;
        self.circleBtn.layer.borderWidth = 3.0f;
        [self.circleBtn setTitle:@"𝔅" forState:UIControlStateNormal];
        [self.circleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.circleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        [self.circleBtn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.circleBtn];
        
        // 2. THE CONSOLE (Terminal style)
        self.consoleView = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 170, 220, 320)];
        self.consoleView.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.95];
        self.consoleView.layer.borderColor = [UIColor redColor].CGColor;
        self.consoleView.layer.borderWidth = 1.5f;
        self.consoleView.hidden = YES;
        [self addSubview:self.consoleView];
        
        // 3. ADMIN COMMANDS
        NSDictionary *commands = @{
            @"FLY": @":fly",
            @"NOCLIP": @":noclip",
            @"SPEED 100": @":speed 100",
            @"JUMP 200": @":jump 200",
            @"GOD MODE": @":god",
            @"ESP": @":esp",
            @"INVISIBLE": @":invisible",
            @"BTOOLS": @":btools",
            @"CTRL-TP": @":tptomouse",
            @"ANTI-LAG": @":lowgfx"
        };
        
        NSArray *keys = [commands allKeys];
        for (int i = 0; i < keys.count; i++) {
            UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(5, 5 + (i * 45), 210, 40)];
            b.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
            [b setTitle:[NSString stringWithFormat:@"> %@", keys[i]] forState:UIControlStateNormal];
            [b setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            b.titleLabel.font = [UIFont fontWithName:@"Courier" size:13];
            b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            // Modern way to add padding (fixing your warning)
            b.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0); 
            
            b.layer.borderWidth = 0.5f;
            b.layer.borderColor = [UIColor darkGrayColor].CGColor;
            
            // This is the line that was failing - it's fixed now with the import!
            objc_setAssociatedObject(b, "lua_code", commands[keys[i]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [b addTarget:self action:@selector(execCmd:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.consoleView addSubview:b];
        }
        self.consoleView.contentSize = CGSizeMake(220, keys.count * 45 + 10);
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) return nil;
    return hitView;
}

- (void)toggle {
    self.consoleView.hidden = !self.consoleView.hidden;
}

- (void)execCmd:(UIButton *)sender {
    NSString *lua = objc_getAssociatedObject(sender, "lua_code");
    printf("[CONSOLE] Executing: %s\n", [lua UTF8String]);
    
    [UIView animateWithDuration:0.1 animations:^{
        sender.backgroundColor = [UIColor greenColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            sender.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        }];
    }];
}
@end

static void __attribute__((constructor)) init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *win = nil;
        // Fix for the 'windows' deprecated warning
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                win = ((UIWindowScene *)scene).windows.firstObject;
                break;
            }
        }
        if (win) {
            BlocksMenu *menu = [[BlocksMenu alloc] initWithFrame:win.bounds];
            [win addSubview:menu];
        }
    });
}
