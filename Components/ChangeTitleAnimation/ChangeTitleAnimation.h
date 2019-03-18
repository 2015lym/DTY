//
//  ChangeTitleAnimation.h
//  ChangeTitle
//
//  Created by LML on 15/12/3.
//  Copyright © 2015年 LML-PC. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  该工具类实现自动生成标题栏与标题下方的线(类似大麦)
 *  使用时需要传入整个控件的frame, 标题数组, 标题常规颜色, 标题被选中时颜色, 下方线的颜色以及标题字号 
 *  增加默认值, frame, 标题数组必须传入, 标题常规颜色不传默认黑, 被选中颜色和下方线颜色默认红, 标题字号默认12
 *  如果需要得到选中标题的序号(这里从1开始)需要遵循 ChangeTitleAnimationDelegate 协议,
 *  并使用 - (void)getPresentTitleNumber:(NSInteger)titleNumber 方法得到当前点击的标题是第几个.
 *  通过对外控制方法 - (void)changeTitleByValue:(NSInteger)value 来控制内部title变化
 *  用于例如滚动视图, tableView 变化对应的标题改变
 */

/**
 *  标题小于4个是平均分, 标题大于4个使用滚动视图控制.
 *  如果标题数量大于4个,使用 self.automaticallyAdjustsScrollViewInsets = NO
 *  修复ScrollView自动偏移的问题
 */

@protocol ChangeTitleAnimationDelegate <NSObject>

/**
 *  用于得到当前点击的title序号 默认序号从1开始
 *
 *  @param titleNumber title序号
 */
- (void)getPresentTitleNumber:(NSInteger)titleNumber;

@end

@interface ChangeTitleAnimation : UIView

/**
 *  标题数组
 */
@property(nonatomic, retain)NSArray *titleArray;

/**
 *  标题点击颜色
 */
@property(nonatomic, retain)UIColor *titleSelectedColor;

/**
 *  标题颜色
 */
@property(nonatomic, retain)UIColor *titleColor;

/**
 *  下方线的颜色
 */
@property(nonatomic, retain)UIColor *lineColor;

/**
 *  字体
 */
@property(nonatomic, assign)CGFloat sizeOfFont;

/**
 *  对外接口, 用于外界(例如滚动视图滚动)对当前标题的变化
 *
 *  @param value 传入的控制值, 对应上方的标题 传入从1开始到最后一个标题的序号即可.
 */
- (void)changeTitleByValue:(NSInteger)value;

//初始化
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray titleColor:(UIColor *)titleColor titleSelectedColor:(UIColor *)titleSelectedColor lineColor:(UIColor *)lineColor sizeOfFont:(CGFloat)size;

+ (ChangeTitleAnimation *)ChangeTitleAnimationWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray titleColor:(UIColor *)titleColor titleSelectedColor:(UIColor *)titleSelectedColor lineColor:(UIColor *)lineColor sizeOfFont:(CGFloat)size;
//按钮点击方法
- (void)titleTouchAction:(UIButton *)sender;
@property(nonatomic, assign)id <ChangeTitleAnimationDelegate> delegate;

@end
