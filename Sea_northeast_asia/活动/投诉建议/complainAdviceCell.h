//
//  complainAdviceCell.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/12/14.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UITableViewCellEx.h"
#import "EGOImageView.h"
@interface complainAdviceCell : UITableViewCellEx
{
    IBOutlet UILabel *lab_title;
    IBOutlet UILabel *lab_isEnroll;
    IBOutlet UILabel *lab_date;
    
    
    IBOutlet EGOImageView *image_Header;
    __weak IBOutlet UILabel *lblLine;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_back;
@property (weak, nonatomic) IBOutlet UILabel *lbl_type;
@end
