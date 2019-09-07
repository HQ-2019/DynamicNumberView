//
//  ViewController.m
//  FFDynamicNumberView
//
//  Created by huangqun on 2019/9/7.
//  Copyright © 2019 hq. All rights reserved.
//

#import "ViewController.h"
#import "FFDynamicNumberView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FFDynamicNumberView *numberView = [FFDynamicNumberView new];
    numberView.backgroundColor = UIColor.yellowColor;
    numberView.numberColor = UIColor.redColor;
    numberView.frame = CGRectMake(30, 150, 200, 100);
    [self.view addSubview:numberView];
    [numberView updateNumbers:399 animation:AnimationTypeScrollUp duration:1];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [numberView updateNumbers:874 animation:AnimationTypeScrollUp duration:3];
    });
}


@end
