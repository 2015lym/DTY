//
//  BaseTabBarViewController.m
//  LYM
//
//  Created by Lym on 2017/7/15.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "BaseTabBarViewController.h"
//#import "HomeViewController_map.h"
//#import "GZTViewController.h"
//#import "MyViewController.h"
//#import "HomeViewController.h"
//#import <SVProgressHUD/SVProgressHUD.h>
//#import "Util.h"
//#import "WorkTableViewController.h"

@interface BaseTabBarViewController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) NSMutableArray *tabbarArray;
@end

@implementation BaseTabBarViewController
//
//#pragma mark - ---------- 生命周期 ----------
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//	// 设置item属性
//	[self setupItem];
//
//	// 添加所有的子控制器
//	[self setAllViewControllers];
//
//	self.delegate = self;
//
//    if (@available(iOS 11, *)) {
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0)
//                                                             forBarMetrics:UIBarMetricsDefault];
//    } else {
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                             forBarMetrics:UIBarMetricsDefault];
//    }
//    [UITabBar appearance].translucent = NO;
//    [UINavigationBar appearance].translucent = NO;
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;
//
////    // 导航栏背景颜色
////    [[UINavigationBar appearance] setBarTintColor:[CommonUseClass getSysColor_gray_back]];
////    // 导航栏返回按钮、自定义UIBarButtonItem颜色
////    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:[UIColor blackColor]}];
//
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//
//#pragma mark - ---------- tabBarController的delegate1 ----------
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//	return YES;
//}
//
//#pragma mark - ---------- tabBarController的delegate2 ----------
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//	NSLog(@"你点击了%@",viewController.title);
//}
//
//#pragma mark - ---------- 添加子控制器 ----------
//- (void)setAllViewControllers {
//    _tabbarArray = [NSMutableArray array];
//
//    [self setChildVC:[HomeViewController_map new]
//               title:@"救援"
//               image:@"tab-救援-未选中"
//       selectedImage:@"tab-救援-选中"];
//
//    [self setChildVC:[WorkTableViewController new]
//               title:@"工作台"
//               image:@"tab-工作台-未选中"
//       selectedImage:@"tab-工作台-选中"];
//
//    [self setChildVC:[MyViewController new]
//               title:@"我的"
//               image:@"tab-我的-未选中"
//       selectedImage:@"tab-我的-选中"];
//}
//
///**
// * 添加一个子控制器
// * @param title 文字
// * @param image 图片
// * @param selectedImage 选中时的图片
// */
//#pragma mark - ---------- 添加子控制器的方法 ----------
//- (void)setChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
//	UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:vc];
//	[self addChildViewController:navigationVC];
//	vc.title = title;
//	navigationVC.tabBarItem.image = [self imageWithRenderOriginalImageName:image];
//	navigationVC.tabBarItem.selectedImage = [self imageWithRenderOriginalImageName:selectedImage];
//    [_tabbarArray addObject:navigationVC];
//}
//
//#pragma mark - ---------- 图片替换 ----------
//- (UIImage *)imageWithRenderOriginalImageName:(NSString *)picName{
//	UIImage * img = [UIImage imageNamed:picName];
//	img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//	return img;
//}
//
//#pragma mark - ---------- 设置item属性 ----------
//- (void)setupItem {
//	// UIControlStateNormal状态下的文字属性
//	NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
//	// 文字颜色
//    normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#333333"];
//
//	// 文字大小
//	normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
//
//	// UIControlStateSelected状态下的文字属性
//	NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
//    // 文字选中颜色
//    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#004E9F"];
//
//	// 统一给所有的UITabBarItem设置文字属性
//	// 只有后面带有UI_APPEARANCE_SELECTOR的属性或方法, 才可以通过appearance对象来统一设置
//	UITabBarItem *item = [UITabBarItem appearance];
//	[item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
//	[item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
//
////    [self.tabBar setBarTintColor:[CommonUseClass getSysColor_gray_back]];
//}

@end
