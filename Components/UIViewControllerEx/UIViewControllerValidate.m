//
//  UIViewControllerValidator.m
//  HIChat
//
//  Created by Song Ques on 14-7-28.
//  Copyright (c) 2014年 Song Ques. All rights reserved.
//

#import "UIViewControllerValidate.h"
#import "AppDelegate.h"

@interface UIViewControllerValidate ()

@end

@implementation UIViewControllerValidate

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
        if (dic_validate==nil) {
            dic_validate=[NSMutableDictionary dictionary];
//            if(app.userInfoEntity!=nil)
//            {
//                [dic_validate setObject:app.userInfoEntity.uid forKey:@"uid"];
//                if (app.userInfoEntity.uguid!=nil) {
//                    [dic_validate setObject:app.userInfoEntity.uguid forKey:@"uguid"];
//                }
//                if (app.userInfoEntity.uname!=nil) {
//                    [dic_validate setObject:app.userInfoEntity.uname forKey:@"uname"];
//                }
//                if (app.userInfoEntity.pwd!=nil) {
//                    [dic_validate setObject:app.userInfoEntity.pwd forKey:@"pwd" ];
//                }
//                if (app.userInfoEntity.username!=nil) {
//                    [dic_validate setObject:app.userInfoEntity.username forKey:@"username"];
//                }
//            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshValidate];
}

-(void)refreshValidate
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    dic_validate=[NSMutableDictionary dictionary];
//    if(app.userInfoEntity!=nil)
//    {
//        if(app.userInfoEntity.uid==nil||
//           app.userInfoEntity.uguid==nil||
//           app.userInfoEntity.uname==nil||
//           app.userInfoEntity.pwd==nil||
//           [app.userInfoEntity.uid isEqualToString:@""]||
//           [app.userInfoEntity.uguid isEqualToString:@""]||
//           [app.userInfoEntity.uname isEqualToString:@""]||
//           [app.userInfoEntity.pwd isEqualToString:@""])
//        {
//            app.userInfoEntity=nil;
//            NSUserDefaults *dic_oAuth=[NSUserDefaults standardUserDefaults];
//            [dic_oAuth setObject:@"NO" forKey:oAuthKey];
//            [dic_oAuth removeObjectForKey:PassWordKey];
//            [app.xmppStream setMyJID:nil];
//            [app disconnect];
//            [app.BPushMeDelegate initPushServices];
//            [app loginShow];
//        }
//        else
//        {
//            [dic_validate setObject:app.userInfoEntity.uid forKey:@"uid"];
//            [dic_validate setObject:app.userInfoEntity.uguid forKey:@"uguid"];
//            [dic_validate setObject:app.userInfoEntity.uname forKey:@"uname"];
//            [dic_validate setObject:app.userInfoEntity.pwd forKey:@"pwd" ];
//            if (app.userInfoEntity.username!=nil) {
//                [dic_validate setObject:app.userInfoEntity.username forKey:@"username"];
//            }
//        }
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dealloc
{
//    LOGPRINT();
}

@end
