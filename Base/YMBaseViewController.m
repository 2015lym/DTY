//
//  YMBaseViewController.m
//  LYM
//
//  Created by Lym on 2017/7/14.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "YMBaseViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SVProgressHUD.h>

@interface YMBaseViewController ()

@end

@implementation YMBaseViewController

#pragma mark - ---------- 生命周期 ----------
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self hideProgress];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
//        NSLog(@"点击返回键");
    }
}

#pragma mark - ---------- SVProgressHUD ----------
- (void)showProgress {
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.label.textColor = [UIColor whiteColor];
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
    hud.label.text = @"正在加载";
    [hud hideAnimated:YES afterDelay:10];
}

- (void)hideProgress {
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

- (void)showSuccess:(NSString *)string {
    [SVProgressHUD isVisible];
    [SVProgressHUD showSuccessWithStatus:string];
    [SVProgressHUD dismissWithDelay:1];
}

- (void)showInfo:(NSString *)string {
	[SVProgressHUD showInfoWithStatus:string];
	[SVProgressHUD dismissWithDelay:1];
}

#pragma mark - ---------- infoPlist ----------
- (NSArray *)getArrayFromInfoPlist:(NSString *)resource and:(NSString *)key {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:resource ofType:@"plist"];
    NSMutableDictionary *usersDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    return [NSArray arrayWithArray:usersDic[key]];
}
    
- (NSDictionary *)getDictionaryFromInfoPlist:(NSString *)resource and:(NSString *)key {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:resource ofType:@"plist"];
    NSMutableDictionary *usersDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    return [NSDictionary dictionaryWithDictionary:usersDic[key]];
}
    
#pragma mark - ---------- alertController ----------
- (void)showAlertControllerNoCancel:(NSString *)title callBack:(YMAlertBlock)alertblock {
    UIAlertController *Sign=[UIAlertController
                             alertControllerWithTitle:title
                             message:nil
                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Yes=[UIAlertAction
                        actionWithTitle:@"确定"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * _Nonnull action) {
                            if (alertblock) {
                                alertblock();
                            }
                        }];
    [Sign addAction:Yes];
    [self presentViewController:Sign animated:YES completion:nil];
}

- (void)showAlertController:(NSString *)title callBack:(YMAlertBlock)alertblock {
    [self showAlertController:title content:nil callBack:alertblock];
}

- (void)showAlertController:(NSString *)title content:(NSString *)content callBack:(YMAlertBlock)alertblock {
    UIAlertController *Sign=[UIAlertController
                             alertControllerWithTitle:title
                             message:content
                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *No=[UIAlertAction
                       actionWithTitle:@"取消"
                       style:UIAlertActionStyleDefault
                       handler:nil];
    UIAlertAction *Yes=[UIAlertAction
                        actionWithTitle:@"确定"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * _Nonnull action) {
                            if (alertblock) {
                                alertblock();
                            }
                        }];
    [Sign addAction:No];
    [Sign addAction:Yes];
    [self presentViewController:Sign animated:YES completion:nil];
}

- (void)showToast:(NSString *)string {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    if( [view viewWithTag:7899] ){                                      //如果tag为789的视图存在
        [[view viewWithTag:7899] removeFromSuperview];
    }
    if(string.length == 0){
        return;
    }
    //显示提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.tag = 7899;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = string;
    hud.margin = 10.f;
    hud.offset = CGPointMake(hud.offset.x, 180);
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.label.textColor = [UIColor whiteColor];
    [[UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]] setColor:[UIColor whiteColor]];
    [hud hideAnimated:YES afterDelay:1];
}

@end
