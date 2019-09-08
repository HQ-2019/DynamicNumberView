//
//  ViewController.m
//  FFDynamicNumberView
//
//  Created by huangqun on 2019/9/7.
//  Copyright © 2019 hq. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "FFDynamicNumberView.h"

@interface ViewController ()

@property (nonatomic, strong) FFDynamicNumberView *numberView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numberView = [FFDynamicNumberView new];
    self.numberView.backgroundColor = UIColor.purpleColor;
    self.numberView.numberColor = UIColor.blackColor;
    self.numberView.numberBackColor = UIColor.whiteColor;
    self.numberView.numberSpace = 20;
    self.numberView.numberFont = [UIFont boldSystemFontOfSize:17];
    self.numberView.numberAlignment = NumberAlignmentCenter;
    [self.view addSubview:self.numberView];
    //    self.numberView.frame = CGRectMake((self.view.frame.size.width - 200) / 2, 100, 200, 40);
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(150);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(60);
    }];
    [self.numberView layoutIfNeeded];
    
    // 设置默认展示的数字
    [self.numberView updateNumbers:1555 animation:AnimationTypeAutomatic duration:0.5];
    
    CGFloat top = 250;
    [self buildButtonWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, top, 100, 40)
                         title:@"做减法"
                        action:@selector(subductionAction)];
    [self buildButtonWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, top += 50, 100, 40)
                         title:@"做加法"
                        action:@selector(additionAction)];
    [self buildButtonWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, top += 50, 100, 40)
                         title:@"随机数滚动"
                        action:@selector(randomAction)];
    [self buildButtonWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, top += 50, 100, 40)
                         title:@"随机数无滚动"
                        action:@selector(randomNoneAction)];
}

- (void)buildButtonWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.backgroundColor = UIColor.grayColor;
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)subductionAction {
    // 确保最小值不能小于100
    if (self.numberView.currentNumber - 55 > 100) {
        [self.numberView updateNumbers:self.numberView.currentNumber - 55 animation:AnimationTypeAutomatic duration:0.3];
    }
//    [self.numberView updateNumbers:521 animation:AnimationTypeAutomatic duration:3];
}

- (void)additionAction {
    [self.numberView updateNumbers:self.numberView.currentNumber + 55 animation:AnimationTypeAutomatic duration:0.3];
//    [self.numberView updateNumbers:521 animation:AnimationTypeAutomatic duration:0.3];
}

- (void)randomAction {
    [self.numberView updateNumbers:arc4random() % 10000 animation:AnimationTypeAutomatic duration:0.3];
}

- (void)randomNoneAction {
    [self.numberView updateNumbers:arc4random() % 10000 animation:AnimationTypeNone duration:0.3];
}


@end
