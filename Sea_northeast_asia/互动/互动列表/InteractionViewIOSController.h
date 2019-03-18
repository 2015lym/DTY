//
//  InteractionViewIOSController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/8/12.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractionCourseViewController.h"
#import "SchoolCourseDelegate.h"
@interface InteractionViewIOSController : UIViewControllerEx<SchoolCourseDelegate,UIActionSheetDelegate>
{
    InteractionCourseViewController *scvc;
    IBOutlet UIView *view_Conout;
}
-(void)navRightBtn_Event;
@end
