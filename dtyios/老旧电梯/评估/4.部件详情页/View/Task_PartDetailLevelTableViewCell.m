//
//  Task_PartDetailLevelTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/17.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_PartDetailLevelTableViewCell.h"

@implementation Task_PartDetailLevelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Task_PartDetailLevelTableViewCell";
    Task_PartDetailLevelTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Task_PartDetailLevelTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(ElevatorAssessmentItemEntityList *)model {
    _model = model;
    _titleLabel.text = model.Requirement;
    //  严重程度
    if ([model.SeverityLevel isEqualToString:@"1"]) {
        _severityLevelLabel.text = @"高";
    } else if ([model.SeverityLevel isEqualToString:@"2"]) {
        _severityLevelLabel.text = @"中";
    } else if ([model.SeverityLevel isEqualToString:@"3"]) {
        _severityLevelLabel.text = @"低";
    } else if ([model.SeverityLevel isEqualToString:@"4"]) {
        _severityLevelLabel.text = @"可忽略";
    } else {
        if (_isPreview) {
            _severityLevelLabel.text = @"";
        } else {
            _severityLevelLabel.text = @"请选择";
        }
    }
    
    // 失效概率等级
    if ([model.ProbabilityLevel isEqualToString:@"1"]) {
        _probabilityLevelLabel.text = @"频繁";
    } else if ([model.ProbabilityLevel isEqualToString:@"2"]) {
        _probabilityLevelLabel.text = @"很可能";
    } else if ([model.ProbabilityLevel isEqualToString:@"3"]) {
        _probabilityLevelLabel.text = @"偶尔";
    } else if ([model.ProbabilityLevel isEqualToString:@"4"]) {
        _probabilityLevelLabel.text = @"极少";
    } else if ([model.ProbabilityLevel isEqualToString:@"5"]) {
        _probabilityLevelLabel.text = @"不大可能";
    } else if ([model.ProbabilityLevel isEqualToString:@"6"]) {
        _probabilityLevelLabel.text = @"不可能";
    } else {
        if (_isPreview) {
            _probabilityLevelLabel.text = @"";
        } else {
            _probabilityLevelLabel.text = @"请选择";
        }
    }
    
    CGFloat height = 15;
    CGRect titleRect = [model.Requirement boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    height += titleRect.size.height;
    height += 15 + 18 + 25 + 18 + 15;
    _viewHeight.constant = height;
}

- (IBAction)severityLevelAction:(id)sender {
    if (_isPreview) return;
    if ([self.delegate respondsToSelector:@selector(selectAction:andIndexPath:)]) {
        [self.delegate selectAction:SeverityLevel andIndexPath:_indexPath];
    }
}

- (IBAction)ProbabilityLevelAction:(id)sender {
    if (_isPreview) return;
    if ([self.delegate respondsToSelector:@selector(selectAction:andIndexPath:)]) {
        [self.delegate selectAction:ProbabilityLevel andIndexPath:_indexPath];
    }
}

@end
