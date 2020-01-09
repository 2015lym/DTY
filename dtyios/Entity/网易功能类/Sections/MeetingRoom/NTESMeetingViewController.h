//
//  NTESMeetingViewController.h
//  NIM
//
//  Created by fenric on 16/4/7.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "YMBaseViewController.h"

@interface NTESMeetingViewController : YMBaseViewController
{
    UILabel *labTime;
    int nTimeCount;
    NSTimer *timer;
}

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom;
@property (nonatomic,strong) AppDelegate *app;
@property (nonatomic,strong) NSString *charRoomName;

@property (nonatomic,strong) NSString *JSTXType;

@property (nonatomic) int isCall;//1call
@end
