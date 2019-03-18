//
//  YJFXMainViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/18.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UITableViewExViewController.h"
#import "UITableViewExForDeleteViewController.h"
#import "LiftHelpViewController.h"
@interface YJFXMainViewController : UIViewController<UITableViewExViewDelegate>
{
    UITableViewExForDeleteViewController *CourseTableview;
}
@property (nonatomic,strong) AppDelegate *app;
@property (nonatomic,strong) NSString *categoryType;
@end


