//
//  Task_PartDetailTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/17.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_PartDetailTableViewCell.h"

@implementation Task_PartDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Task_PartDetailTableViewCell";
    Task_PartDetailTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Task_PartDetailTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(ElevatorAssessmentItemEntityList *)model {
    _model = model;
    _titleLabel.text = model.Requirement;
    //  状态
    if ([model.IdentificationStatus isEqualToString:@"1"]) {
        _statusLabel.text = @"符合";
    } else if ([model.IdentificationStatus isEqualToString:@"2"]) {
        _statusLabel.text = @"不符合";
    } else {
        if (_isPreview) {
            _statusLabel.text = @"";
        } else {
            _statusLabel.text = @"请选择";
        }
    }
    
    
    CGFloat height = 15;
    CGRect titleRect = [model.Requirement boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    height += titleRect.size.height;
    height += 15 + 18 + 15;
    _viewHeight.constant = height;
}

- (IBAction)selectAction:(id)sender {
    if (_isPreview) return;
    if ([self.delegate respondsToSelector:@selector(selectAction:andIndexPath:)]) {
        [self.delegate selectAction:IdentificationStatus andIndexPath:_indexPath];
    }
}

@end
