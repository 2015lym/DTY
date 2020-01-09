//
//  TZTGViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/15.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UITableViewExViewController.h"
#import "TZTGDetailViewController.h"
@interface TZTGViewController : UIViewControllerEx<UITableViewExViewDelegate> {
    UITableViewExViewController *CourseTableview;
}
@property (nonatomic,strong) AppDelegate *app;

@end
