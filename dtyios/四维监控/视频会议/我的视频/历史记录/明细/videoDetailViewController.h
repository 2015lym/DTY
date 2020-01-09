//
//  videoDetailViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/13.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerEx.h"
#import "UITableViewExViewController.h"
#import "CourseHearView.h"
#import "AFAppDotNetAPIClient.h"
#import "SchoolCourseDelegate.h"
#import "appDelegate.h"
#import "XXNet.h"
@interface videoDetailViewController : UIViewController<UITableViewExViewDelegate,CourseHearViewDelegate>
{
    UITableViewExViewController *CourseTableview;
    CourseHearView *HeaderView;
    NSString *currTag;
}
@property(nonatomic,strong)NSString *tag;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,weak)id<SchoolCourseDelegate> delegate;
@property(nonatomic,strong)NSMutableDictionary *dic_info;
@property (nonatomic,strong) AppDelegate *app;
@end
