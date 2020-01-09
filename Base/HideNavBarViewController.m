//
//  HideNavBarViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/3/26.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "HideNavBarViewController.h"

@interface HideNavBarViewController ()<UINavigationControllerDelegate>

@end

@implementation HideNavBarViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)dealloc {
    self.navigationController.delegate = nil;
}

@end
