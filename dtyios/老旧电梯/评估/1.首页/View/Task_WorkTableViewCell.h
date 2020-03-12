//
//  Task_WorkTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/5.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task_WorkListModel.h"

@interface Task_WorkTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *elevatorNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) Task_WorkListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
