//
//  Task_BaseInfoTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_BaseInfoTableViewCell.h"

@implementation Task_BaseInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Task_BaseInfoTableViewCell";
    Task_BaseInfoTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Task_BaseInfoTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(Task_WorkDetailModel *)model {
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
    
    _productNumberLabel.text = [NSString stringWithFormat:@"产品编号：%@", model.ProductNumber];
    
    if (model.ElevatorType == 0) {
        _typeLabel.text = @"电梯类型：客梯";
    } else if (model.ElevatorType == 1) {
        _typeLabel.text = @"电梯类型：扶梯";
    } else {
        _typeLabel.text = @"电梯类型：货梯";
    }
    _modelLabel.text = [NSString stringWithFormat:@"型号：%@", model.ElevatorModel];
    
    _completeTimeLabel.text = [NSString stringWithFormat:@"任务完成时间：%@", model.CompletionTime];
}

@end
