//
//  CourseTableViewCell.h
//  AlumniChat
//
//  Created by SongQues on 16/6/15.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCellEx.h"
#import "EGOImageView.h"
@interface InteractionCourseTableViewCell : UITableViewCellEx
{
   IBOutlet UILabel *lab_title;
   IBOutlet UILabel *lab_isEnroll;
    
      IBOutlet EGOImageView *image_Header;
    
    IBOutlet UILabel *lab_nikeName;
    IBOutlet UILabel *lab_time;
    
    IBOutlet UIView *backView;
}
@end
