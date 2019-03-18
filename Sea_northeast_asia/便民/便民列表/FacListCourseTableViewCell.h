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
#import "baiduMap.h"
@interface FacListCourseTableViewCell : UITableViewCellEx<UIActionSheetDelegate>
{
   IBOutlet UILabel *lab_title;
   IBOutlet UILabel *lab_isEnroll;    
    IBOutlet UILabel *lab_km;
    
    IBOutlet UILabel *lab_title1;
    IBOutlet UILabel *lab_isEnroll1;
   IBOutlet EGOImageView *image_Header;
      IBOutlet EGOImageView *image_Header1;
      IBOutlet EGOImageView *image_Header2;
    
    IBOutlet EGOImageView *image_phone;
    IBOutlet EGOImageView *image_phoneHave;
    IBOutlet EGOImageView *image_area;
    __weak IBOutlet UILabel *lblLine;
    IBOutlet UIView *view;
    
    NSString *phoneNumber;
    NSString *longitude;
    NSString *latitude;
}

- (IBAction)chickArea:(id)sender;
@property(nonatomic,weak)id<baiduMapDelegate> delegate;
@end
