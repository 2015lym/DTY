//
//  YMBaseViewController.h
//  LYM
//
//  Created by Lym on 2017/7/14.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YMAlertBlock)(void);

@interface YMBaseViewController : UIViewController
@property (nonatomic, strong) UIView *blankView;
// 展示、隐藏Progress，一般用于网络请求
- (void)showProgress;
- (void)hideProgress;

// 成功提示
- (void)showSuccess:(NSString *)string;

// 普通、失败提示
- (void)showInfo:(NSString *)string;

// Toast 提示
- (void)showToast:(NSString *)string;

// alertController 提示
- (void)showAlertController:(NSString *)title callBack:(YMAlertBlock)alertblock;
- (void)showAlertControllerNoCancel:(NSString *)title callBack:(YMAlertBlock)alertblock;
- (void)showAlertController:(NSString *)title content:(NSString *)content callBack:(YMAlertBlock)alertblock;

@end
