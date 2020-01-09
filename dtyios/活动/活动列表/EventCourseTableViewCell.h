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
@interface EventCourseTableViewCell : UITableViewCellEx
{
   IBOutlet UILabel *lab_title;
   IBOutlet UILabel *lab_start;
    IBOutlet UILabel *lab_end;
    IBOutlet UILabel *lab_nameCount;
    
    
    __weak IBOutlet UILabel *lab_back;
    
   IBOutlet EGOImageView *image_Header;
    
     IBOutlet UIView *memoView;
    
}
@property(nonatomic,strong) UIButton *btnArea;
@end
