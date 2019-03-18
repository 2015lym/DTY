//
//  handleRecorde.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/10.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIViewControllerEx.h"
#import "UITableViewExViewController.h"
#import "CourseHearView.h"
#import "AFAppDotNetAPIClient.h"
#import "SchoolCourseDelegate.h"
#import "appDelegate.h"
@interface handleRecorde : UIViewControllerEx<UITableViewExViewDelegate,CourseHearViewDelegate>
{
    UITableViewExViewController *CourseTableview;
    CourseHearView *HeaderView;
    NSString *currTag;
}
@property(nonatomic,strong)NSString *tag;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,weak)id<SchoolCourseDelegate> delegate;
@property(nonatomic,strong)NSMutableDictionary *dic_school_info;
@property (nonatomic,strong) AppDelegate *app;
@end
