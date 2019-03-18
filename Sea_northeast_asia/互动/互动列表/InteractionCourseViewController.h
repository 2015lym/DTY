//
//  InteractionCourseViewController.h
//  Sea_northeast_asia
//
//  Created by Macinstosh on 16/8/30.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerEx.h"
#import "UITableViewExViewController.h"
#import "CourseHearView.h"
#import "AFAppDotNetAPIClient.h"
#import "SchoolCourseDelegate.h"
#import "EventCurriculumEntity.h"
@interface InteractionCourseViewController :  UIViewControllerEx<UITableViewExViewDelegate,CourseHearViewDelegate>
{
    UITableViewExViewController *CourseTableview;
    //CourseHearView *HeaderView;
    NSString *currTag;
}
@property(nonatomic,strong)NSString *tag;
@property(nonatomic,weak)id<SchoolCourseDelegate> delegate;
@property(nonatomic,strong)NSMutableDictionary *dic_school_info;
-(void)getSchoolCourse;
@end
