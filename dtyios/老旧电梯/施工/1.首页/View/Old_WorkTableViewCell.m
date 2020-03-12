//
//  Old_WorkTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/5.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Old_WorkTableViewCell.h"

@implementation Old_WorkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Old_WorkTableViewCell";
    Old_WorkTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = (Old_WorkTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(Part_WorkListModel *)model {
    _model = model;
    _elevatorNumberLabel.text = [NSString stringWithFormat:@"电梯注册代码：%@", model.CertificateNum];
    _addressLabel.text = [NSString stringWithFormat:@"安装地址：%@", model.CommunityDetailedAddress];
    _useTimeLabel.text = [NSString stringWithFormat:@"电梯使用时间：%@年", model.ElevatorUsageTime];
    _doneTimeLabel.text = [NSString stringWithFormat:@"评估完成时间：%@年", model.CompletionTime];
    _statusLabel.text = [NSString stringWithFormat:@"任务状态：%@", model.FlowStatusName];
}

@end
