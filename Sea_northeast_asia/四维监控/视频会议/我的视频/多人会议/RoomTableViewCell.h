//
//  RoomTableViewCell.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/5/27.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "UITableViewCellEx.h"
#import "EGOImageView.h"
@interface RoomTableViewCell : UITableViewCellEx

@property (weak, nonatomic) IBOutlet UILabel *lab_Name;

@property (weak, nonatomic) IBOutlet UILabel *lab_Detail;
@property (weak, nonatomic) IBOutlet UILabel *line;


@end
