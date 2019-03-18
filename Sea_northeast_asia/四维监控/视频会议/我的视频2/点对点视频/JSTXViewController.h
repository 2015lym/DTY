//
//  JSTXViewController.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/6/1.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESService.h"
#import <NIMAVChat/NIMNetCallOption.h>
//记得导入这个框架
#import <AVFoundation/AVFoundation.h>

@protocol NTESMeetingNetCallManagerDelegate <NSObject>

@required

- (void)onJoinMeetingFailed:(NSString *)name error:(NSError *)error;

- (void)onMeetingConntectStatus:(BOOL)connected;

- (void)onSetBypassStreamingEnabled:(BOOL)enabled error:(NSUInteger)code;


@end




@interface JSTXViewController : UIViewController

- (void)joinMeeting:(NSString *)name delegate:(id<NTESMeetingNetCallManagerDelegate>)delegate;

@property (nonatomic,strong) NSDictionary *dict;


@end
