//
//  ChangeTitleAnimation.m
//  ChangeTitle
//
//  Created by LML on 15/12/3.
//  Copyright © 2015年 LML-PC. All rights reserved.
//

#import "ChangeTitleAnimation.h"

#define kCenterY self.frame.size.height - 1

@interface ChangeTitleAnimation ()
@property(nonatomic, retain)UIView *line;
@property(nonatomic, assign)CGPoint lastCenter;

/**
 *  第一次被选中的标题
 */
@property(nonatomic, retain)UIButton *already;

@end

@implementation ChangeTitleAnimation

- (void)dealloc
{
    [_titleSelectedColor release];
    [_line release];
    [_titleArray release];
    [_titleColor release];
    [_lineColor release];
    [super dealloc];
}

+ (ChangeTitleAnimation *)ChangeTitleAnimationWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray titleColor:(UIColor *)titleColor titleSelectedColor:(UIColor *)titleSelectedColor lineColor:(UIColor *)lineColor sizeOfFont:(CGFloat)size {
    
    ChangeTitleAnimation *change = [[ChangeTitleAnimation alloc] initWithFrame:frame titleArray:titleArray titleColor:titleColor titleSelectedColor:titleSelectedColor lineColor:lineColor sizeOfFont:size];
    return [change autorelease];
}

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray titleColor:(UIColor *)titleColor titleSelectedColor:(UIColor *)titleSelectedColor lineColor:(UIColor *)lineColor sizeOfFont:(CGFloat)size
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = titleArray;
        if (titleColor) {
            self.titleColor = titleColor;
        } else {
            self.titleColor = [UIColor blackColor];
        }
        
        if (titleSelectedColor) {
            self.titleSelectedColor = titleSelectedColor;
        } else {
            self.titleSelectedColor = [UIColor redColor];
        }
        
        if (lineColor) {
            self.lineColor = lineColor;
        } else {
            self.lineColor = [UIColor colorWithRed:20.f/255.0 green:96.f/255.0 blue:190.f/255.0 alpha:1];
        }
        
        if (size) {
            self.sizeOfFont = size;
        } else {
            self.sizeOfFont = 12;
        }

        //四个或一下不需要滚动视图
        if (self.titleArray.count <= 5) {
            [self drawWithFrame:frame];
        }
        //四个以上需要滚动视图
        else {
            [self drawUseScrollAndFrame:frame];
        }
    }
    return self;
}

//tag 从100开始
#pragma mark 5个以下标题使用的初始化方法
- (void)drawWithFrame:(CGRect)frame {
    
    CGFloat singleLetterWidth = [self heightOfSelfSuit:@"我" font:[UIFont systemFontOfSize:self.sizeOfFont] width:100] + 2;
    CGFloat buttonWidth = frame.size.width / self.titleArray.count;
    
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, frame.size.height);
        button.tag = i + 100;
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:self.sizeOfFont];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(titleTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    //默认第一个按钮被选中
    UIButton *button = (UIButton *)[self viewWithTag:100];
    button.selected = YES;
    self.already = button;
    
    //初始化一条线
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 5, 2)];
    UIButton *first = (UIButton *)[self viewWithTag:100];
    CGFloat centerX = first.center.x;
    self.line.center = CGPointMake(centerX, kCenterY);
    self.lastCenter = self.line.center;
    self.line.backgroundColor = self.lineColor;
    [self addSubview:self.line];
    [_line release];
}

#pragma mark 5个以上标题使用的初始化方法
- (void)drawUseScrollAndFrame:(CGRect)frame {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    scrollView.contentSize = CGSizeMake(self.titleArray.count * frame.size.width / 5.0, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.tag = 101010;
    [self addSubview:scrollView];
    [scrollView release];
    
    CGFloat singleLetterWidth = [self heightOfSelfSuit:@"我" font:[UIFont systemFontOfSize:self.sizeOfFont] width:100] + 2;
    CGFloat buttonWidth = frame.size.width / 5;
    
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, frame.size.height);
        button.tag = i + 100;
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:self.sizeOfFont];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(titleTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
    }
    
    //默认第一个按钮被选中
    UIButton *button = (UIButton *)[self viewWithTag:100];
    button.selected = YES;
    self.already = button;
    
    //初始化一条线
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, singleLetterWidth * [self.titleArray[0] length], 2)];
    UIButton *first = (UIButton *)[self viewWithTag:100];
    CGFloat centerX = first.center.x;
    self.line.center = CGPointMake(centerX, kCenterY);
    self.lastCenter = self.line.center;
    self.line.backgroundColor = self.lineColor;
    [scrollView addSubview:self.line];
    [_line release];
    
}

#pragma mark 外界传值控制事件
- (void)changeTitleByValue:(NSInteger)value {
    
    NSInteger tag = value + 99;
    UIButton *sender = (UIButton *)[self viewWithTag:tag];
    
    if (!sender.selected) {
        sender.selected = !sender.selected;
        if (self.already != sender) {
            self.already.selected = !self.already.selected;
            self.already = sender;
        }else {
            self.already = nil;
        }
    }
    
    [self.delegate getPresentTitleNumber:sender.tag - 99];
    
    CGFloat centerX = sender.center.x;
//    CGFloat singleLetterWidth = [self heightOfSelfSuit:@"我" font:[UIFont systemFontOfSize:self.sizeOfFont] width:100] + 2;
    [UIView animateWithDuration:0.5 animations:^{
        self.line.frame = CGRectMake(0, 0, self.frame.size.width / 5, 2);
        self.line.center = self.lastCenter;
        self.line.center = CGPointMake(centerX, kCenterY);
        self.lastCenter = self.line.center;
        
        //如果标题大于5个, 对第5个和之后设置滚动时跟随偏移量 (只在外界操作有)
        if (self.titleArray.count >= 5) {
            UIScrollView *scroll = (UIScrollView *)[self viewWithTag:101010];
            if (value >= 5) {
                CGFloat offsetX = (value - 5) * self.frame.size.width / 5;
                [scroll setContentOffset:CGPointMake(offsetX, 0) animated:YES];
            } else {
                [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            
        }
    }];

    
}

#pragma mark 标题被点中的点击事件
- (void)titleTouchAction:(UIButton *)sender {
    
    if (!sender.selected) {
        sender.selected = !sender.selected;
        if (self.already != sender) {
            self.already.selected = !self.already.selected;
            self.already = sender;
        }else {
            self.already = nil;
        }
    }
    
    [self.delegate getPresentTitleNumber:sender.tag - 99];
    
    CGFloat centerX = sender.center.x;
//    CGFloat singleLetterWidth = [self heightOfSelfSuit:@"我" font:[UIFont systemFontOfSize:self.sizeOfFont] width:100] + 2;
    [UIView animateWithDuration:0.5 animations:^{
            self.line.frame = CGRectMake(0, 0, self.frame.size.width / 5, 2);
            self.line.center = self.lastCenter;
            self.line.center = CGPointMake(centerX, kCenterY);
            self.lastCenter = self.line.center;
        }];
}

#pragma mark 计算一个字的高度, 用于画线.
- (CGFloat)heightOfSelfSuit:(NSString *)text font:(UIFont *)font width:(CGFloat)width {
    
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSDictionary *style = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect result = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:style context:nil];
    return result.size.height;
}

@end
