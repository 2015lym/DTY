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
@interface CourseTableViewCell : UITableViewCellEx
{
   IBOutlet UILabel *lab_title;
   IBOutlet UILabel *lab_isEnroll;
    IBOutlet UILabel *lab_date;
    
    IBOutlet UILabel *lab_title1;
    IBOutlet UILabel *lab_isEnroll1;
   IBOutlet EGOImageView *image_Header;
      IBOutlet EGOImageView *image_Header1;
      IBOutlet EGOImageView *image_Header2;
    __weak IBOutlet UILabel *lblLine;
}
@end
