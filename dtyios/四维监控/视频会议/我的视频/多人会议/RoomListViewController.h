//
//  RoomListViewController.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/5/27.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UITableViewExViewController.h"
#import "UITableViewExForDeleteViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NTESService.h"
#import <NIMAVChat/NIMNetCallOption.h>
#import "NTESMeetingNetCallManager.h"
//@protocol NTESMeetingNetCallManagerDelegate <NSObject>
//
//@required
//
//- (void)onJoinMeetingFailed:(NSString *)name error:(NSError *)error;
//
//- (void)onMeetingConntectStatus:(BOOL)connected;
//
//- (void)onSetBypassStreamingEnabled:(BOOL)enabled error:(NSUInteger)code;
//
//
//@end

//@protocol NTESActorSelectViewDelegate <NSObject>
//
//- (void)onSelectedAudio:(BOOL)audioOn video:(BOOL)videoOn whiteboard:(BOOL)whiteboardOn;
//
//@end



@interface RoomListViewController : UIViewController<UITableViewExViewDelegate>

{
    UITableViewExForDeleteViewController *CourseTableview;
}
@property (nonatomic,strong) AppDelegate *app;

@property(nonatomic, readonly) BOOL isInMeeting;

//- (void)joinMeeting:(NSString *)name delegate:(id<NTESMeetingNetCallManagerDelegate>)delegate;

- (void)leaveMeeting;

- (BOOL)setBypassLiveStreaming:(BOOL)enabled;


//@property (nonatomic, weak) id<NTESActorSelectViewDelegate> delegate;

@property (nonatomic,strong) NSDictionary *dict;
@end
