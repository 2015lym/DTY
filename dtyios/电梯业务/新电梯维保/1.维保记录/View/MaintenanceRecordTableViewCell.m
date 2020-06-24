//
//  MaintenanceRecordTableViewCell.m
//  dtyios
//
//  Created by Lym on 2020/6/9.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceRecordTableViewCell.h"

@implementation MaintenanceRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_tagLabel hyb_addCornerRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"MaintenanceRecordTableViewCell";
    MaintenanceRecordTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (MaintenanceRecordTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(MaintenanceRecordModel *)model {
    _model = model;
    _timeLabel.text = [model.MaintenanceDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    _tagLabel.text = model.WorkOrderStatusName;
//    if ([model.WorkOrderStatusName isEqualToString:@"未进行"]) {
//
//    } else if ([model.WorkOrderStatusName isEqualToString:@"进行中"]) {
//
//    } else if ([model.WorkOrderStatusName isEqualToString:@"待审核"]) {
//
//    } else if ([model.WorkOrderStatusName isEqualToString:@"待签字"]) {
//
//    } else if ([model.WorkOrderStatusName isEqualToString:@"已完成"]) {
//
//    } else {
//
//    }
    _codeLabel.text = [NSString stringWithFormat:@"注册代码：%@", model.CertificateNum];
    _addressLabel.text = [NSString stringWithFormat:@"安装地址：%@", model.DetailAddress];
    _typeLabel.text = [NSString stringWithFormat:@"维保类型：%@", model.TypeName];
    NSMutableString *peopleList = [[NSMutableString alloc] init];
    for (NSString *people in model.MaintenanceUserNameList) {
        [peopleList appendString:people];
        [peopleList appendString:@"、"];
    }
    _peopleLabel.text = [NSString stringWithFormat:@"维保人员：%@", [peopleList substringToIndex:peopleList.length - 1]];
    _codeLabel.text = [NSString stringWithFormat:@"注册代码：%@", model.CertificateNum];
    
    if (model.workStatus == 7) {
        NSString *lastDate = [model.PlanMaintenanceTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        _timeLabel.text = [NSString stringWithFormat:@"到期时间：%@", lastDate];
        NSString *planTime = [model.PlanMaintenanceTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSInteger timeResult = [DateService getNowTimeInterval] - [DateService stringToTimeInterval:planTime];
        if (timeResult > 0) {
            _overLabel.hidden = NO;
            _overLabel.text = [NSString stringWithFormat:@"已超期%ld天", timeResult/86400];
        }
    }
}

@end
