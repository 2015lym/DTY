//
//  VideoViewController.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/4/1.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface VideoViewController : UIViewController
@property (nonatomic,strong) AppDelegate *app;
@property (nonatomic,strong) NSString *url;
// 定义属性
@property (nonatomic, strong) AVPlayer *player;  
@end
