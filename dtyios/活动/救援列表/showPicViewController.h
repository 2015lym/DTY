//
//  showPicViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/11/30.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyControl.h"
#import "XXNet.h"

#import "AppDelegate.h"
#import "EGOImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface showPicViewController : UIViewController
@property (nonatomic,strong) AppDelegate *app;
@property (nonatomic,strong) NSString *LiftId;
@property (nonatomic,strong) NSString *TaskId;
@end

NS_ASSUME_NONNULL_END
