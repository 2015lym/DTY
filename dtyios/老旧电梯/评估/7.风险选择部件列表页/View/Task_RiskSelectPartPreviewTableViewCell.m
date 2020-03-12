//
//  Task_RiskSelectPartPreviewTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/11.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_RiskSelectPartPreviewTableViewCell.h"

@implementation Task_RiskSelectPartPreviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Task_RiskSelectPartPreviewTableViewCell";
    Task_RiskSelectPartPreviewTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Task_RiskSelectPartPreviewTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(PartsCategoryEntityList *)model {
    _model = model;
    _titleLabel.text = model.AssessmentItemName;
    NSMutableArray *valueArray = [NSMutableArray array];
    for (PartAttributeEntityList *entity in model.itemArray) {
        if (![StringFunction isBlankString:entity.PartAttributeValue]) {
            [valueArray addObject:entity];
        }
    }
    for (int i=0; i<valueArray.count; i++) {
        PartAttributeEntityList *entity = valueArray[i];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + 21 + 8 + i*8 + i*14.5, SCREEN_WIDTH-60, 14.5)];
        lbl.font = [UIFont systemFontOfSize:13.0];
        lbl.textColor = [UIColor lightGrayColor];
        lbl.text = [NSString stringWithFormat:@"%@：%@", entity.PartAttributeName, entity.PartAttributeValue];
        [self.contentView addSubview:lbl];
    }
}
@end
