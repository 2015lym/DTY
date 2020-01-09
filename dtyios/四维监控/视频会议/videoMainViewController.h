//
//  videoMainViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/8/14.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
//网易云信
#import <NIMSDK/NIMSDK.h>
#import "NTESLoginViewController.h"
#import "NTESDemoConfig.h"
#import "NTESCustomAttachmentDecoder.h"
#import "NTESLoginManager.h"
#import "NTESEnterRoomViewController.h"
#import "NTESDataManager.h"
#import "NTESPageContext.h"
#import "NTESLogManager.h"
#import "UIView+Toast.h"

#import "AppDelegate.h"
#import "RoomListViewController.h"
#import "YMBaseViewController.h"

@interface videoMainViewController : YMBaseViewController
{
    NSString *roomid;
}
@property (nonatomic,strong) AppDelegate *app;

-(void)videologin:(NSString *)WYID;
-(void)videologout;
@end
