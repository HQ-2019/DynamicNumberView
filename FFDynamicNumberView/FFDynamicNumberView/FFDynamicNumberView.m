//
//  FFDynamicNumberView.m
//  FFDynamicNumberView
//
//  Created by huangqun on 2019/9/7.
//  Copyright © 2019 hq. All rights reserved.
//

#import "FFDynamicNumberView.h"

/**
 计算单个数字的size
 
 @param font 字体
 @return size
 */
static CGSize singleNumerSize(UIFont *font) {
    CGRect rect = [@"0" boundingRectWithSize:CGSizeZero
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{ NSFontAttributeName: font }
                                     context:nil];
    return rect.size;
}

@interface FFDynamicNumberView ()

@property (nonatomic, strong) NSMutableArray<FFSingleNunberView *> *numberViews; /**< 数字视图列表 */

@end

@implementation FFDynamicNumberView

- (instancetype)init {
    if (self = [super init]) {
        // 设置默认值
        self.numberFont = [UIFont systemFontOfSize:15];
        self.numberColor = UIColor.blackColor;
        self.numberSpace = 5.0;
        self.currentNumber = 0;
    }
    return self;
}

/**
 更新数字
 
 @param numbers 数值
 @param animation 动画类型
 @param duration 动画持续时长
 */
- (void)updateNumbers:(NSUInteger)numbers
            animation:(AnimationType)animation
             duration:(NSTimeInterval)duration {

    // 记录当前的数值
    self.currentNumber = numbers;

    // 将原来多余的数字视图移除
    NSUInteger count = [NSString stringWithFormat:@"%lu", numbers].length;
    if (self.numberViews.count >= count) {
        for (int i = 0; i < self.numberViews.count - count; i++) {
            FFSingleNunberView *numberView = self.numberViews[i];
            [self.numberViews removeObjectAtIndex:i];
            [numberView removeFromSuperview];
            numberView = nil;
        }
    }

    // 根据对齐方式计算第一位数的x坐标
    CGFloat firstX = 0.0;
    // 单个数组的size
    CGSize numberSize = singleNumerSize(self.numberFont);
    // 所有数字占的总宽
    CGFloat numbersWidht = count * numberSize.width + (count - 1) * self.numberSpace;
    switch (self.numberAlignment) {
        case NumberAlignmentRight: {
            firstX = self.frame.size.width - numbersWidht;
            break;
        }
        case NumberAlignmentCenter: {
            firstX = (self.frame.size.width - numbersWidht) / 2;
            break;
        }
        default:
            break;
    }

    // 创建或调整数字视图
    for (int i = 0; i < count; i++) {
        FFSingleNunberView *numberView;
        // 判断是否需要补充视图
        if (self.numberViews.count < count) {
            numberView = [FFSingleNunberView new];
            [self addSubview:numberView];
        }

        // 根据对齐方式计算每个numberView的位置
        CGFloat x = firstX + i * (numberSize.width + self.numberSpace);
        numberView.frame = CGRectMake(x, (self.frame.size.height - numberSize.height) / 2, numberSize.width, numberSize.height);
        [numberView setDispalyNumber:[self subnumberWithNumer:numbers atIndex:i] startNumber:numberView.currentNumber animation:AnimationTypeScrollUp];
        
        [numberView updateViews];
    }
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        for (FFSingleNunberView *numberView in self.numberViews) {
            [numberView updateViews];
        }
    }];
}

/**
 获取数值中指定位置的单个数字
 
 @param number 原数字
 @param index 指定的位置
 @return 单个数字
 */
- (NSUInteger)subnumberWithNumer:(NSUInteger)number atIndex:(NSUInteger)index {
    NSString *numberStr = [NSString stringWithFormat:@"%lu", number];
    NSAssert(numberStr.length > index, @"截取数字索引越界");
    NSUInteger num = 0;
    if (numberStr.length > index) {
        num = [[numberStr substringWithRange:NSMakeRange(index, 1)] integerValue];
    }
    return num;
}

@end

#pragma mark -
#pragma mark - 单个数字视图
@interface FFSingleNunberView ()

@property (nonatomic, strong) UIView *backgroudView; /**< label的区域视图，主要用于裁剪label */
@property (nonatomic, strong) UILabel *numberLabel;  /**< 数字label */

@end

@implementation FFSingleNunberView

- (instancetype)init {
    if (self = [super init]) {
        // 设置默认值
        self.numberFont = [UIFont systemFontOfSize:15];
        self.numberColor = UIColor.blackColor;
        self.currentNumber = 0;
    }
    return self;
}

- (UIView *)backgroudView {
    if (_backgroudView == nil) {
        _backgroudView = [UIView new];
        CGRect rect = self.frame;
        rect.origin = CGPointZero;
        _backgroudView.frame = rect;
//        _backgroudView.clipsToBounds = YES;
        _backgroudView.backgroundColor = UIColor.grayColor;
        [self addSubview:_backgroudView];
    }
    return _backgroudView;
}

- (UILabel *)numberLabel {
    if (_numberLabel == nil) {
        _numberLabel = [UILabel new];
        _numberLabel.textColor = self.numberColor;
        _numberLabel.font = self.numberFont;
        CGRect rect = self.backgroudView.frame;
        rect.origin = CGPointZero;
        _numberLabel.frame = rect;
        [self.backgroudView addSubview:_numberLabel];
    }
    return _numberLabel;
}

/**
 更新label的Y坐标
 */
- (void)updateViews {
    CGRect rect = self.numberLabel.frame;
    rect.origin.y = singleNumerSize(self.numberLabel.font).height - rect.size.height;
    self.numberLabel.frame = rect;
}

/**
 设置将要显示的数值
 计算label的高度
 最后通过改变label的高度来达到滚动的效果

 @param dispalyNumber 将要显示的数字
 @param startNumber 开始时的数字
 @param animation 数字切换的动画（只允许ScrollUp和ScrollDown动画）
 */
- (void)setDispalyNumber:(NSUInteger)dispalyNumber
             startNumber:(NSUInteger)startNumber
               animation:(AnimationType)animation {
    // 只处理向上或向下的滚动动画计算
    if (animation != AnimationTypeScrollUp && animation != AnimationTypeScrollDown) {
        return;
    }

    // 新值和起始值一致时不做动效处理
    if (startNumber == dispalyNumber) {
        // 将label的size恢复成单值的size
    }

    /* label的值取决于两个因素
     * 1、滚动方向
     * 2、开始的数字与最终的数字的大小
     *
     * 列如：向上滚动(加法)
     * 从 6 -> 3，值为 67890123
     * 从 3 -> 6，值为 3456
     *
     * 列如：向下滚动(减法)
     * 从 6 -> 3，值为 6543
     * 从 3 -> 6，值为 32109876
     */
    NSMutableString *numberString = [NSMutableString stringWithFormat:@"%lu", (unsigned long)startNumber];
    if (animation == AnimationTypeScrollUp) {
        if (startNumber < dispalyNumber) {
            for (NSUInteger i = startNumber + 1; i <= dispalyNumber; i++) {
                [numberString appendFormat:@"\n%lu", i];
            }
        } else {
            for (NSUInteger i = startNumber + 1; i < 10; i++) {
                [numberString appendFormat:@"\n%lu", i];
            }
            for (NSUInteger i = 0; i <= dispalyNumber; i++) {
                [numberString appendFormat:@"\n%lu", i];
            }
        }
    } else if (animation == AnimationTypeScrollDown) {
        if (startNumber > dispalyNumber) {
            for (NSUInteger i = startNumber + 1; i <= dispalyNumber; i++) {
                [numberString appendFormat:@"\n%lu", i];
            }
        } else {
            for (NSUInteger i = startNumber - 1; i >= 0; i--) {
                [numberString appendFormat:@"\n%lu", i];
            }
            for (NSUInteger i = 9; i >= dispalyNumber; i--) {
                [numberString appendFormat:@"\n%lu", i];
            }
        }
    }
    
    NSString *text = [numberString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSUInteger numberCount = text.length;
    // 更新label的内容和size
    self.numberLabel.text = numberString;
    self.numberLabel.numberOfLines = numberCount;
    CGSize size = singleNumerSize(self.numberLabel.font);
    CGRect rect = self.numberLabel.frame;
    rect.size.height = size.height * numberCount;
    self.numberLabel.frame = rect;
    
    // 记录当前显示的数值
    self.currentNumber = dispalyNumber;
}

@end

