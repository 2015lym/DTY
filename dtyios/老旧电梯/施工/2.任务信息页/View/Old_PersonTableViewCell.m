//
//  Old_PersonTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Old_PersonTableViewCell.h"

@implementation Old_PersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Old_PersonTableViewCell";
    Old_PersonTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Old_PersonTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(Part_WorkDetailModel *)model {
    _model = model;
    NSArray *dataArray = _model.adminUsers;
    if ([_titleLabel.text isEqualToString:@"任务负责人"]) {
        dataArray = _model.users;
    }
    
    for (int i=0; i<dataArray.count; i++) {
        UserListModel *user = dataArray[i];
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15 + i*8 + i*14.5, 15, 15)];
        if ([_titleLabel.text isEqualToString:@"任务负责人"]) {
            imgv.image = [UIImage imageNamed:@"老旧电梯-负责人"];
        } else {
            imgv.image = [UIImage imageNamed:@"老旧电梯-管理员"];
        }
        [self.peopleView addSubview:imgv];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(30 + 15, 15 + i*8 + i*14.5, SCREEN_WIDTH-60, 14.5)];
        lbl.font = [UIFont systemFontOfSize:13.0];
        lbl.textColor = [UIColor lightGrayColor];
        lbl.text = [NSString stringWithFormat:@"%@  %@", user.UserName, user.UserTelephone];
        [self.peopleView addSubview:lbl];
    }
    _peopleViewHeight.constant = 15 + (dataArray.count - 1)*8 + dataArray.count*14.5 + 15;
}

@end
