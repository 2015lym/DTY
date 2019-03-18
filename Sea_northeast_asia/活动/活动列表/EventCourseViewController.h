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
//#import "EventCourseTableViewCell.h"
@interface EventCourseViewController : UIViewControllerEx<UITableViewExViewDelegate,CourseHearViewDelegate>
{
    UITableViewExViewController *CourseTableview;
   // EventCourseTableViewCell *cell;
   
    NSString *currTag;
}
@property(nonatomic,strong)NSString *tag;
@property(nonatomic,weak)id<SchoolCourseDelegate> delegate;
@property(nonatomic,strong)NSMutableDictionary *dic_school_info;
@end
