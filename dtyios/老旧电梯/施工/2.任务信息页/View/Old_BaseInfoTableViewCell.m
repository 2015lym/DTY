//
//  Old_BaseInfoTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Old_BaseInfoTableViewCell.h"

@implementation Old_BaseInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Old_BaseInfoTableViewCell";
    Old_BaseInfoTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Old_BaseInfoTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(Part_WorkDetailModel *)model {
    _model = model;
    _numberLabel.text = [NSString stringWithFormat:@"注册代码：%@", model.CertificateNum];
    _areaLabel.text = [NSString stringWithFormat:@"所在小区：%@", model.CommunityName];
    _addressLabel.text = [NSString stringWithFormat:@"安装地址：%@", model.CommunityDetailedAddress];
    _buildNumberLabel.text = [NSString stringWithFormat:@"内部编号及楼牌号：%@", model.InternalNumAndBuildingNum];
    if (model.PlaceOfUse == 1) {
        _positionLabel.text = @"使用场所：非住宅";
    } else {
        _positionLabel.text = @"使用场所：住宅";
    }
    _companyLabel.text = [NSString stringWithFormat:@"生产企业：%@", model.ManufacturingUnit];
    _installTimeLabel.text = [NSString stringWithFormat:@"初次安装使用时间：%@", model.InitialInstallationAcceptanceTime];
    _useCompanyLabel.text = [NSString stringWithFormat:@"使用单位：%@", model.PropertyCompany];
    _repaireCompanyLabel.text = [NSString stringWithFormat:@"维保单位：%@", model.MaintenanceCompany];
    
    if (model.ElevatorType == 0) {
        _typeLabel.text = @"电梯类型：客梯";
    } else if (model.ElevatorType == 1) {
        _typeLabel.text = @"电梯类型：扶梯";
    } else {
        _typeLabel.text = @"电梯类型：货梯";
    }
    _modelLabel.text = [NSString stringWithFormat:@"型号：%@", model.ElevatorModel];
}

- (void)setEnvModel:(Task_WorkDetailModel *)envModel {
    _envModel = envModel;
    _numberLabel.text = [NSString stringWithFormat:@"注册代码：%@", envModel.CertificateNum];
    _areaLabel.text = [NSString stringWithFormat:@"所在小区：%@", envModel.CommunityName];
    _addressLabel.text = [NSString stringWithFormat:@"安装地址：%@", envModel.CommunityDetailedAddress];
    _buildNumberLabel.text = [NSString stringWithFormat:@"内部编号及楼牌号：%@", envModel.InternalNumAndBuildingNum];
    if (envModel.PlaceOfUse == 1) {
        _positionLabel.text = @"使用场所：非住宅";
    } else {
        _positionLabel.text = @"使用场所：住宅";
    }
    _companyLabel.text = [NSString stringWithFormat:@"生产企业：%@", envModel.ManufacturingUnit];
    _installTimeLabel.text = [NSString stringWithFormat:@"初次安装使用时间：%@", envModel.InitialInstallationAcceptanceTime];
    _useCompanyLabel.text = [NSString stringWithFormat:@"使用单位：%@", envModel.PropertyCompany];
    _repaireCompanyLabel.text = [NSString stringWithFormat:@"维保单位：%@", envModel.MaintenanceCompany];
    
    if (envModel.ElevatorType == 0) {
        _typeLabel.text = @"电梯类型：客梯";
    } else if (envModel.ElevatorType == 1) {
        _typeLabel.text = @"电梯类型：扶梯";
    } else {
        _typeLabel.text = @"电梯类型：货梯";
    }
    _modelLabel.text = [NSString stringWithFormat:@"型号：%@", envModel.ElevatorModel];
}

@end
