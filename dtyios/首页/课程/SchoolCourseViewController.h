//
//  SchoolCourseViewController.h
//  AlumniChat
//
//  Created by SongQues on 16/6/15.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "UIViewControllerEx.h"
#import "UITableViewExViewController.h"
#import "CourseHearView.h"
#import "AFAppDotNetAPIClient.h"
#import "SchoolCourseDelegate.h"
@interface SchoolCourseViewController : UIViewControllerEx<UITableViewExViewDelegate,CourseHearViewDelegate>
{
    UITableViewExViewController *CourseTableview;
    CourseHearView *HeaderView;
    NSString *currTag;
}
@property(nonatomic,strong)NSString *tag;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,weak)id<SchoolCourseDelegate> delegate;
@property(nonatomic,strong)NSMutableDictionary *dic_school_info;
@end
