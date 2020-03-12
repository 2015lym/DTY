//
//  Task_RiskPartDetailTableViewCell2.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/17.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_RiskPartDetailTableViewCell2.h"

@implementation Task_RiskPartDetailTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Task_RiskPartDetailTableViewCell2";
    Task_RiskPartDetailTableViewCell2 *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Task_RiskPartDetailTableViewCell2 *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(ElevatorAssessmentItemEntityList *)model {
    _model = model;
    _titleLabel.text = model.Requirement;
    
    if ([model.SeverityLevel isEqualToString:@"1"]) {
        _severityLevelLabel.text = @"严重程度：高";
    } else if ([model.SeverityLevel isEqualToString:@"2"]) {
        _severityLevelLabel.text = @"严重程度：中";
    } else if ([model.SeverityLevel isEqualToString:@"3"]) {
        _severityLevelLabel.text = @"严重程度：低";
    } else {
        _severityLevelLabel.text = @"严重程度：可忽略";
    }
    
    if ([model.ProbabilityLevel isEqualToString:@"1"]) {
        _probabilityLevelLabel.text = @"失效概率等级：频繁";
    } else if ([model.ProbabilityLevel isEqualToString:@"2"]) {
        _probabilityLevelLabel.text = @"失效概率等级：很可能";
    } else if ([model.ProbabilityLevel isEqualToString:@"3"]) {
        _probabilityLevelLabel.text = @"失效概率等级：偶尔";
    } else if ([model.ProbabilityLevel isEqualToString:@"4"]) {
        _probabilityLevelLabel.text = @"失效概率等级：极少";
    } else if ([model.ProbabilityLevel isEqualToString:@"5"]) {
        _probabilityLevelLabel.text = @"失效概率等级：不大可能";
    } else {
        _probabilityLevelLabel.text = @"失效概率等级：不可能";
    }
    
    if (model.RiskDescription && model.RiskDescription.length > 0) {
        _riskDescriptionLabel.text = @"已填写";
    } else {
        _riskDescriptionLabel.text = @"未填写";
    }
    
    if (model.Solution && model.Solution.length > 0) {
        _solutionLabel.text = @"已填写";
    } else {
        _solutionLabel.text = @"未填写";
    }
    
    _riskCategoriesLabel.text = [NSString stringWithFormat:@"风险类别：%@", model.RiskCategories];
    
    
    
    CGFloat height = 15;
    CGRect titleRect = [model.Requirement boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    height += titleRect.size.height;
    height += 8 + 16 + 8 + 16 + 15 + 18 + 25 + 18 + 25;
    _viewHeight.constant = height;
}

- (IBAction)riskDescriptionAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectAction:andIndexPath:)]) {
        [self.delegate selectAction:RiskDescription andIndexPath:_indexPath];
    }
}

- (IBAction)solutionAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectAction:andIndexPath:)]) {
        [self.delegate selectAction:Solution andIndexPath:_indexPath];
    }
}

@end
