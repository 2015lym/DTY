//
//  ChatVoiceRecorderVC.h
//  Jeans
//
//  Created by Jeans on 3/23/13.
//  Copyright (c) 2013 Jeans. All rights reserved.
//

#import "VoiceRecorderBaseVC.h"


//#define kCancelOriginY          (kRecorderViewRect.origin.y + kRecorderViewRect.size.height + 180)
#define kCancelOriginY          ([[UIScreen mainScreen]bounds].size.height-70)

@interface ChatVoiceRecorderVC : VoiceRecorderBaseVC

@property (nonatomic)BOOL isTouch; //是否触点判断
//开始录音
- (void)beginRecordByFileName:(NSString*)_fileName;

@end
