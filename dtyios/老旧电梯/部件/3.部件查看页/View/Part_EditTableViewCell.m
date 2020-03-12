//
//  Part_EditTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/11.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Part_EditTableViewCell.h"

@implementation Part_EditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Part_EditTableViewCell";
    Part_EditTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Part_EditTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (IBAction)editBind:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellEditAction:andIndexPath:)]) {
        [self.delegate cellEditAction:edit_bind andIndexPath:_indexPath];
    }
}

- (IBAction)editBack:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellEditAction:andIndexPath:)]) {
        [self.delegate cellEditAction:edit_back andIndexPath:_indexPath];
    }
}

- (IBAction)editChange:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellEditAction:andIndexPath:)]) {
        [self.delegate cellEditAction:edit_change andIndexPath:_indexPath];
    }
}

- (void)setModel:(Part_PreviewModel *)model {
    _model = model;
    _titleLabel.text = model.PartName;
    
    NSMutableArray *valueArray = [NSMutableArray arrayWithArray:model.entityArray];
    for (BindPartModel *part in model.parts) {
        PartAttributeEntityListModel *e1 = [PartAttributeEntityListModel new];
        e1.PartAttributeName = @"部件编码";
        e1.PartAttributeValue = part.ProductNumber;
        [valueArray addObject:e1];
        PartAttributeEntityListModel *e2 = [PartAttributeEntityListModel new];
        if (part.QRCode.length > 0) {
            e2.PartAttributeName = @"激光二维码";
            e2.PartAttributeValue = part.QRCode;
            
        } else {
            e2.PartAttributeName = @"nfc编码";
            e2.PartAttributeValue = part.NfcNumber;
        }
        [valueArray addObject:e2];
        if (part.QRCode.length > 0 && part.NfcNumber.length > 0) {
            PartAttributeEntityListModel *e3 = [PartAttributeEntityListModel new];
            e3.PartAttributeName = @"nfc编码";
            e3.PartAttributeValue = part.NfcNumber;
            [valueArray addObject:e3];
        }
        
    }

    for (int i=0; i<valueArray.count; i++) {
        PartAttributeEntityListModel *entity = valueArray[i];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + 21 + 8 + i*8 + i*14.5, SCREEN_WIDTH-60, 14.5)];
        lbl.font = [UIFont systemFontOfSize:13.0];
        lbl.textColor = [UIColor lightGrayColor];
        lbl.text = [NSString stringWithFormat:@"%@：%@", entity.PartAttributeName, entity.PartAttributeValue];
        [self.contentView addSubview:lbl];
    }
    
    
    if ([model.FlowStatusName containsString:@"未绑定"]) {
        _bindButton.hidden = NO;
        _backButton.hidden = YES;
        _changeButton.hidden = YES;
        if (model.localBind) {
            _bindButton.hidden = YES;
            _backButton.hidden = YES;
            _changeButton.hidden = NO;
        }
    } else if ([model.FlowStatusName containsString:@"已绑定"]) {
        _bindButton.hidden = YES;
        _backButton.hidden = YES;
        _changeButton.hidden = NO;
    } else {
        _bindButton.hidden = YES;
        _backButton.hidden = NO;
        _changeButton.hidden = NO;
    }
}

@end
