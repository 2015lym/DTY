//
//  Env_WorkTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Env_WorkListModel.h"

@interface Env_WorkTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *elevatorNumberLabel;

@property (nonatomic, strong) Env_WorkListModel *model;


+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end


