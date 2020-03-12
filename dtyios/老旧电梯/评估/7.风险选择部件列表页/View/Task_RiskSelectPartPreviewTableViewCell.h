//
//  Task_RiskSelectPartPreviewTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/11.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Task_RiskPartModel.h"

@interface Task_RiskSelectPartPreviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) PartsCategoryEntityList *model;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
