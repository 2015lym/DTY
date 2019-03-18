//
//  VideoListViewController.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/8/11.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UITableViewExViewController.h"
#import "UITableViewExForDeleteViewController.h"

@interface VideoListViewController : UIViewController <UITableViewExViewDelegate>
{
    UITableViewExForDeleteViewController *CourseTableview;
}
@property (nonatomic,strong) AppDelegate *app;


@end
