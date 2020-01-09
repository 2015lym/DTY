//
//  CourseHearView.h
//  AlumniChat
//
//  Created by SongQues on 16/7/1.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "SchoolCourseDelegate.h"

@protocol CourseHearViewDelegate <NSObject>
@required
-(void)CourseHearOnClick:(UIViewControllerEx *) vc;
@end
@interface CourseHearView : UIView<SDCycleScrollViewDelegate>
{
    SDCycleScrollView *bannerView;
    NSMutableArray *arr_data;
}
-(UIView *)initview:(NSMutableArray *) arr;
@property(nonatomic,assign)NSInteger showCount;
@property(nonatomic,weak)id<CourseHearViewDelegate> delegate;
@end
