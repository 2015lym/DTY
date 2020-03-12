//
//  Old_ElevatorTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Old_ElevatorTableViewCell.h"

@implementation Old_ElevatorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Old_ElevatorTableViewCell";
    Old_ElevatorTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Old_ElevatorTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(Part_WorkDetailModel *)model {
    _model = model;
    
    _layerStationDoorLabel.text = [NSString stringWithFormat:@"层站门：%@", model.LayerStationDoor];
    
    if (model.OpeningDirection == 0) {
        _openingDirectionLabel.text = @"开门方向：左";
    } else if (model.OpeningDirection == 1) {
        _openingDirectionLabel.text = @"开门方向：右";
    } else {
        _openingDirectionLabel.text = @"开门方向：中分";
    }
    
    _tractionRatioLabel.text = [NSString stringWithFormat:@"曳引比：%@", model.TractionRatio];
    
    _wireRopeLabel.text = [NSString stringWithFormat:@"钢丝绳数量：%ld根", model.WireRope];
    
    _ratedSpeedLabel.text = [NSString stringWithFormat:@"额定速度：%@m/s", model.RatedSpeed];
    
    _ratedLoadLabel.text = [NSString stringWithFormat:@"额定载重量：%@kg", model.RatedLoad];

    if (model.DrivingMode == 0) {
        _drivingModeLabel.text = @"控制方式：单速";
    } else if (model.DrivingMode == 1) {
        _drivingModeLabel.text = @"控制方式：双速";
    } else if (model.DrivingMode == 2) {
        _drivingModeLabel.text = @"控制方式：交调";
    } else if (model.DrivingMode == 3) {
        _drivingModeLabel.text = @"控制方式：直流";
    } else {
        _drivingModeLabel.text = @"控制方式：变频";
    }
    
    if (model.PortalCraneDrivingMode == 0) {
        _portalCraneDrivingModeLabel.text = @"门机驱动方式：直流";
    } else if (model.PortalCraneDrivingMode == 1) {
        _portalCraneDrivingModeLabel.text = @"门机驱动方式：交流";
    }  else {
        _portalCraneDrivingModeLabel.text = @"门机驱动方式：变频";
    }
    
    if (model.InorganicRoom == 0) {
        _inorganicRoomLabel.text = @"有无机房：有";
    }  else {
        _inorganicRoomLabel.text = @"有无机房：无";
    }
    
    if (model.ClosingMode == 0) {
        _closingModeLabel.text = @"防夹装置：光幕";
    }  else {
        _closingModeLabel.text = @"防夹装置：触板";
    }
    
    if ([StringFunction isBlankString:model.MotorPower]) {
        _motorPowerLabel.text = @"电动机功率：kw";
    } else {
        _motorPowerLabel.text = [NSString stringWithFormat:@"电动机功率：%@kw", model.MotorPower];
    }
    
    if (model.IsBreakthrough == 0) {
        _isBreakthroughLabel.text = @"是否贯通：是";
    }  else {
        _isBreakthroughLabel.text = @"是否贯通：否";
    }
    
}

- (void)setEnvModel:(Task_WorkDetailModel *)envModel {
    _envModel = envModel;
    _layerStationDoorLabel.text = [NSString stringWithFormat:@"层站门：%@", envModel.LayerStationDoor];
    
    if (envModel.OpeningDirection == 0) {
        _openingDirectionLabel.text = @"开门方向：左";
    } else if (envModel.OpeningDirection == 1) {
        _openingDirectionLabel.text = @"开门方向：右";
    } else {
        _openingDirectionLabel.text = @"开门方向：中分";
    }
    
    _tractionRatioLabel.text = [NSString stringWithFormat:@"曳引比：%@", envModel.TractionRatio];
    
    _wireRopeLabel.text = [NSString stringWithFormat:@"钢丝绳数量：%ld根", envModel.WireRope];
    
    _ratedSpeedLabel.text = [NSString stringWithFormat:@"额定速度：%@m/s", envModel.RatedSpeed];
    
    _ratedLoadLabel.text = [NSString stringWithFormat:@"额定载重量：%@kg", envModel.RatedLoad];
    
    if (envModel.DrivingMode == 0) {
        _drivingModeLabel.text = @"控制方式：单速";
    } else if (envModel.DrivingMode == 1) {
        _drivingModeLabel.text = @"控制方式：双速";
    } else if (envModel.DrivingMode == 2) {
        _drivingModeLabel.text = @"控制方式：交调";
    } else if (envModel.DrivingMode == 3) {
        _drivingModeLabel.text = @"控制方式：直流";
    } else {
        _drivingModeLabel.text = @"控制方式：变频";
    }
    
    if (envModel.PortalCraneDrivingMode == 0) {
        _portalCraneDrivingModeLabel.text = @"门机驱动方式：直流";
    } else if (envModel.PortalCraneDrivingMode == 1) {
        _portalCraneDrivingModeLabel.text = @"门机驱动方式：交流";
    }  else {
        _portalCraneDrivingModeLabel.text = @"门机驱动方式：变频";
    }
    
    if (envModel.InorganicRoom == 0) {
        _inorganicRoomLabel.text = @"有无机房：有";
    }  else {
        _inorganicRoomLabel.text = @"有无机房：无";
    }
    
    if (envModel.ClosingMode == 0) {
        _closingModeLabel.text = @"防夹装置：光幕";
    }  else {
        _closingModeLabel.text = @"防夹装置：触板";
    }
    
    if ([StringFunction isBlankString:envModel.MotorPower]) {
        _motorPowerLabel.text = @"电动机功率：kw";
    } else {
        _motorPowerLabel.text = [NSString stringWithFormat:@"电动机功率：%@kw", envModel.MotorPower];
    }
    
    
    if (envModel.IsBreakthrough == 0) {
        _isBreakthroughLabel.text = @"是否贯通：是";
    }  else {
        _isBreakthroughLabel.text = @"是否贯通：否";
    }
}
@end
