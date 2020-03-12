//
//  Examine_WorkTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/5.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Examine_WorkListModel.h"


@interface Examine_WorkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *elevatorNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIButton *outButton;

@property (nonatomic, strong) Examine_WorkListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
