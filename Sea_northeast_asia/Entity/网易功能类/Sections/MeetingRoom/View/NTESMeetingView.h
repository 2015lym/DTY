//
//  NTESMeetingView.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/6/12.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTESMeetingView : UIView

@property (nonatomic) BOOL isFullScreen;

@property (nonatomic) BOOL showFullScreenBtn;

- (void)updateActors;

-(void)stopLocalPreview;

@end
