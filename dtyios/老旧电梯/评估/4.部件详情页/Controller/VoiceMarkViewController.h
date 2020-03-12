//
//  VoiceMarkViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/4/9.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"

@protocol VoiceMarkViewControllerDelegate <NSObject>

- (void)voicePath:(NSString *)fileName;

@end

@interface VoiceMarkViewController : YMBaseViewController

@property (nonatomic, weak) id<VoiceMarkViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *fileName; // 文件名
@property (nonatomic, assign) BOOL isPreview;
@property (nonatomic, assign) BOOL isUpload;

@end

