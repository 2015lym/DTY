//
//  rescueList.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/8.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewExViewController.h"
#import "UIViewControllerEx.h"
#import "CourseHearView.h"
#import "appDelegate.h"
@interface rescueList : UIViewController<UITableViewExViewDelegate>
{
 UITableViewExViewController *CourseTableview;
}

@property (strong, nonatomic)  NSMutableArray *arr;

@property (nonatomic,strong) AppDelegate *app;
@end
