//
//  MaintenanceNFCListTableViewCell.m
//  dtyios
//
//  Created by Lym on 2020/7/3.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceNFCListTableViewCell.h"
#import "MaintenanceContentModel.h"

@implementation MaintenanceNFCListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"MaintenanceNFCListTableViewCell";
    MaintenanceNFCListTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (MaintenanceNFCListTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(AppMaintenanceWorkRecordNfcDtos *)model {
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"%ld. %@", _indexPath.section + 1, model.PartName];;
    if (model.ElevatorPartNFCId.length > 0 && model.ElevatorPartNFCIdValue.length == 0) {
        _recognitionLabel.text = @"未识别";
    } else {
        _recognitionLabel.text = @"已识别";
        _rightButton.hidden = YES;
    }
    
    _nfcIdLabel.text = [NSString stringWithFormat:@"标签值：%@", model.ElevatorPartNFCIdValue];
    _nfcNumLabel.text = [NSString stringWithFormat:@"唯一值：%@", model.NFCNum];
    _dateLabel.text = [NSString stringWithFormat:@"绑定时间：%@", model.ElevatorPartFactoryDate];
}

- (IBAction)recognitionAction:(UIButton *)sender {
}

@end
