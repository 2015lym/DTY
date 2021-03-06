//
//  NTESMeetingNetCallManager.h
//  NIMEducationDemo
//
//  Created by fenric on 16/4/24.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESService.h"

#import <NIMAVChat/NIMNetCallOption.h>
#import "AppDelegate.h"
#import "XXNet.h"
@protocol NTESMeetingNetCallManagerDelegate <NSObject>

@required

- (void)onJoinMeetingFailed:(NSString *)name error:(NSError *)error;

- (void)onMeetingConntectStatus:(BOOL)connected;

- (void)onSetBypassStreamingEnabled:(BOOL)enabled error:(NSUInteger)code;


@end

@interface NTESMeetingNetCallManager : NTESService

@property(nonatomic, readonly) BOOL isInMeeting;
@property (nonatomic,strong) AppDelegate *app;
- (void)joinMeeting:(NSString *)name delegate:(id<NTESMeetingNetCallManagerDelegate>)delegate;

- (void)joinMeeting2:(NSString *)name delegate:(id<NTESMeetingNetCallManagerDelegate>)delegate;

- (void)joinMeeting3:(NSString *)name delegate:(id<NTESMeetingNetCallManagerDelegate>)delegate;

- (void)leaveMeeting;

- (BOOL)setBypassLiveStreaming:(BOOL)enabled;

@end
