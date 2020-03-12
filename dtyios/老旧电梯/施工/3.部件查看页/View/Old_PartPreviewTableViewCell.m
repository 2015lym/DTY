//
//  Old_PartPreviewTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/11.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Old_PartPreviewTableViewCell.h"

@implementation Old_PartPreviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Old_PartPreviewTableViewCell";
    Old_PartPreviewTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Old_PartPreviewTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
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
}
@end
