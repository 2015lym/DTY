//
//  videoHistroyCell.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/13.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UITableViewCellEx.h"
#import "EGOImageView.h"
@interface videoHistroyCell : UITableViewCellEx
@property (nonatomic,strong) AppDelegate *app;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UIButton *checkCell;

@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblRoleName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet EGOImageView *imgHead;

@end
