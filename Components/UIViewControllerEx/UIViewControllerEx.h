//
//  UIViewControllerEx.h
//  YONChat
//
//  Created by SongQues on 14/11/6.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UITabBarController+makeTabBarHidden.h"
#import "Util.h"
#import "PECropViewController.h"
#import "UIViewControllerValidate.h"
//#import "XMPPEvent.h"
@class AppDelegate;
@interface UIViewControllerEx : UIViewControllerValidate<UIGestureRecognizerDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *checkinLocation;
    NSString *Provinces;
    NSString *City;
    NSDate *Date_Location;
}
@property (nonatomic,strong) AppDelegate *app;
@property (nonatomic) BOOL thrift_Location;
@property (nonatomic) BOOL is_Location;
///设置导航栏
- (void)setNav;
///由于手动开启了自带滑动返回手势，进行此设置防止滑动返回时界面卡死（如果一个navigationController手动开启了滑动返回所有通过该navigationController push进来的视图控制器都需要在push之前调用此方法，不然有可能出现界面假死）
//- (void)preSetNavForSlide;
-(IBAction)nav_back:(id)sender;
-(void)pushViewController:(UIViewController*)pushViewController  animated:(BOOL)animated;
- (void) setupLocationManager;

@end
