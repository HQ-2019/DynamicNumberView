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
    self.numberView.numberColor = UIColor.redColor;
    self.numberView.numberSpace = 10;
    self.numberView.numberFont = [UIFont boldSystemFontOfSize:17];
    self.numberView.numberAlignment = NumberAlignmentCenter;
    [self.view addSubview:self.numberView];
    //    self.numberView.frame = CGRectMake((self.view.frame.size.width - 200) / 2, 100, 200, 40);
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(100);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    [self.numberView layoutIfNeeded];
    
    // 设置默认展示的数字
    [self.numberView updateNumbers:1055 animation:AnimationTypeNone duration:0];
    
    
    [self buildButtonWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, 400, 100, 40) title:@"-" action:@selector(subductionAction)];
    [self buildButtonWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, 450, 100, 40) title:@"+" action:@selector(additionAction)];
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
//    [self.numberView updateNumbers:self.numberView.currentNumber - 100 animation:AnimationTypeAutomatic duration:0.3];
    [self.numberView updateNumbers:521 animation:AnimationTypeAutomatic duration:0.3];
}

- (void)additionAction {
    [self.numberView updateNumbers:self.numberView.currentNumber + 55  animation:AnimationTypeAutomatic duration:0.3];
//    [self.numberView updateNumbers:521 animation:AnimationTypeAutomatic duration:0.3];
}


@end
