//
//  videoMainViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/8/14.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "videoMainViewController.h"
#import "AddPeopleViewController.h"
#import "JSTXViewController.h"
#import "MyControl.h"
@interface videoMainViewController ()

@end

@implementation videoMainViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view.
    
    //test网易云信
    roomid=   @"sinodom2";
    //app.userInfo.UserID=roomid;//AddPeopleViewController的房间号用的是app.userInfo.UserID。需要改。
    
//    NSString *WYID =app.userInfo.username;//@"dengdu11";// @"15040168290";
//    NSString *password=@"123456";//@"16cc44fd1e7ae8516deb3bf224b749bc";
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:WYID forKey:@"WYID"];
    
    
//    [[[NIMSDK sharedSDK] loginManager] login:WYID
//                                       token:password
//                                  completion:^(NSError *error) {
//                                      [SVProgressHUD dismiss];
//                                      if (error == nil)
//                                      {
//                                          NTESLoginData *sdkData = [[NTESLoginData alloc] init];
//                                          sdkData.account   = WYID;
//                                          sdkData.token     = password;
//
//                                          NSLog(@"%@",sdkData);
//
//                                          [[NTESLoginManager sharedManager] setCurrentNTESLoginData:sdkData];
//                                          [[NTESServiceManager sharedManager] start];
//                                      }
//                                      else
//                                      {
//                                          NSString *toast = [NSString stringWithFormat:@"登录失败 code: %zd",error.code];
//                                          //                                          [self makeToast:toast duration:2.0 position:CSToastPositionCenter];
//                                      }
//                                  }];
    
    
    UIButton * btncall = [MyControl createButtonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) imageName:nil bgImageName:nil title:@"call" SEL:@selector(btncallClick:) target:self];
    [self .view addSubview:btncall];
    
    UIButton * btnjoin = [MyControl createButtonWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 50) imageName:nil bgImageName:nil title:@"join" SEL:@selector(btnjoinClick:) target:self];
    [self .view addSubview:btnjoin];
    
    
}

//主叫
- (void)btncallClick:(UIButton*)sender {
    [self call];
}
- (void)call{
    AddPeopleViewController *vc = [[AddPeopleViewController alloc]init];
    vc.roomid=roomid;
    [self.navigationController pushViewController:vc animated:YES];
}

//被叫
- (void)btnjoinClick:(UIButton*)sender {
    NSMutableDictionary * newdic=[NSMutableDictionary new];
    [newdic setValue:roomid forKey:@"roomId"];//@"sinodom2"
    [newdic setValue:@"dy" forKey:@"roomName"];
    
    [self join: newdic];
//    RoomListViewController *vc = [[RoomListViewController alloc] init];
//    vc.dict = newdic;
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)join:(NSDictionary*)userInfo{
    RoomListViewController *vc = [[RoomListViewController alloc] init];
    vc.dict = userInfo;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [app.window.rootViewController presentViewController:nav animated:YES completion:nil];
     //[self presentViewController:nav animated:YES completion:nil];
}

//1:主叫;2:被叫;0:no
-(void)videologin:(NSString *)WYID
{
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *password=@"123456";
    [[[NIMSDK sharedSDK] loginManager] login:WYID
                                       token:password
                                  completion:^(NSError *error) {
                                      [SVProgressHUD dismiss];
                                      if (error == nil)
                                      {
                                          app.videoLoginState=@"1";
                                          NTESLoginData *sdkData = [[NTESLoginData alloc] init];
                                          sdkData.account   = WYID;
                                          sdkData.token     = password;
                                          
                                          NSLog(@"%@",sdkData);
                                          
                                          [[NTESLoginManager sharedManager] setCurrentNTESLoginData:sdkData];
                                          [[NTESServiceManager sharedManager] start];
                                          
                                          
                                      }
                                      else
                                      {
                                          app.videoLoginState=@"0";
                                          NSString *toast = [NSString stringWithFormat:@"视频会议帐号登录失败 code: %zd",error.code];
                                          [MBProgressHUD showError:toast toView:nil];
                                          //                                          [self makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                      }
                                  }];
}

-(void)videologout
{
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        if (error == nil)
        {
            app.videoLoginState=@"0";
            NSLog(@"%@",@"logout ok");
        }
        else
        {
            NSString *toast = [NSString stringWithFormat:@"视频会议帐号登出失败 code: %zd",error.code];
            //            [MBProgressHUD showError:toast toView:nil];
            NSLog(@"%@",toast);
        }
    }];
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

@end
