//
//  UINavViewControllerEx.m
//  YONChat
//
//  Created by SongQues on 14/11/6.
//
//

#import "UINavViewControllerEx.h"
#import "LeftViewController.h"
#import "LoginViewController.h"
#import "PersonController.h"
#import "AppDelegate.h"
@interface UINavViewControllerEx ()

@end

@implementation UINavViewControllerEx

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setNav
{
    [super setNav];
    self.navigationController.delegate = self;
    self.navigationItem.leftBarButtonItem=nil;
}
-(IBAction)pop_messageCenterView:(id)sender
{
 
}
#pragma mark - UIGestureRecognizerDelegate 在根视图时不响应interactivePopGestureRecognizer手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)
        return NO;
    else
        return YES;

}

#pragma mark - navigationDelegate 实现此代理方法也是为防止滑动返回时界面卡死
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
//        int i=self.navigationController.viewControllers.count;
        if (self.navigationController.viewControllers.count <= 1)
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        else
            navigationController.interactivePopGestureRecognizer.enabled = YES;

    }
    
}

@end
