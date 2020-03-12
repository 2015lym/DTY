//
//  Task_WorkTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/5.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_WorkTableViewCell.h"

@implementation Task_WorkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Task_WorkTableViewCell";
    Task_WorkTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = (Task_WorkTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(Task_WorkListModel *)model {
    _model = model;
    _elevatorNumberLabel.text = [NSString stringWithFormat:@"电梯注册代码：%@", model.CertificateNum];
    _addressLabel.text = [NSString stringWithFormat:@"安装地址：%@", model.CommunityDetailedAddress];
    _useTimeLabel.text = [NSString stringWithFormat:@"电梯使用时间：%@年", model.ElevatorUsageTime];
    _doneTimeLabel.text = [NSString stringWithFormat:@"评估完成时间：%@", model.CompletionTime];
    if (model.AssessmentType == 0) {
        _statusLabel.text = @"老旧电梯鉴定评估";
    } else if (model.AssessmentType == 1) {
        _statusLabel.text = @"老旧电梯风险评估";
    } else if (model.AssessmentType == 2) {
        _statusLabel.text = @"老旧电梯维修基金审查";
    } else {
        _statusLabel.text = @"电梯现场监督抽查";
    }
}

@end
