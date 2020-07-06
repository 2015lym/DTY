//
//  LoginViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/13.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "AFAppDotNetAPIClient.h"

#import "appDelegate.h"
#import "TencentOpenAPI/TencentApiInterface.h"
@import AFNetworking;



@interface LoginViewController : UIViewController<WXDelegate,TencentSessionDelegate>//
{
    IBOutlet UITextField *text01;
    IBOutlet UITextField *text02;
    IBOutlet UIButton *btn01;
    IBOutlet UIButton *btn02;
    IBOutlet UILabel *lab01;
    //HomeViewController *homeview;
    TencentOAuth *tencentOAuth;
    NSArray *permissions;
}
//@property(nonatomic,strong)id<HomeShowPersonDelegate>onePerson;

@property (nonatomic,strong) AppDelegate *app;
-(void)navLeftBtn_Event:(id)sender;
-(void)navRightBtn_Event:(id)sender;
- (IBAction)LoginQQ:(id)sender;
- (IBAction)LoginWeixin:(id)sender;


@end
