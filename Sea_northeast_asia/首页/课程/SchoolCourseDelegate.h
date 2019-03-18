//
//  SchoolCourseDelegate.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/8/4.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewControllerEx.h"
@protocol SchoolCourseDelegate <NSObject>
-(void)SchoolCoursePush:(UIViewControllerEx *)vc;
-(void)SchoolCoursePush_newNaV:(UIViewControllerEx *)vc;

@end
