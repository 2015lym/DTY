//
//  MaintenanceAuditContentTableViewCell.m
//  dtyios
//
//  Created by Lym on 2020/6/29.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceAuditContentTableViewCell.h"

@implementation MaintenanceAuditContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"MaintenanceAuditContentTableViewCell";
    MaintenanceAuditContentTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (MaintenanceAuditContentTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(MaintenanceAuditContentModel *)model {
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"%zd. %@", _indexPath.section, model.MaintenanceItemName];
    NSInteger userNum = model.users.count;
    for (int i = 0; i<userNum; i++) {
        UserMaintenanceResult *user = model.users[i];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 16 + 18 + 8 + i*8 + i*17, SCREEN_WIDTH-80, 17)];
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textColor = [UIColor darkGrayColor];
        lbl.text = [NSString stringWithFormat:@"%@：%@", user.UserName, user.ResultName];
        [self.contentView addSubview:lbl];
    }
    
    if (model.nfcs.count > 0 && model.photos.count == 0) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 16 + 18 + 8 + userNum*8 + userNum*17, SCREEN_WIDTH-80, 17)];
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textColor = [UIColor darkGrayColor];
        lbl.text = [NSString stringWithFormat:@"NFC 已识别%zd/%zd", model.nfcs.count, model.nfcs.count];
        [self.contentView addSubview:lbl];
    }
    
    if (model.nfcs.count > 0 && model.photos.count > 0) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 16 + 18 + 8 + userNum*8 + userNum*17, SCREEN_WIDTH-80, 17)];
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textColor = [UIColor darkGrayColor];
        lbl.text = [NSString stringWithFormat:@"NFC 已识别%zd/%zd", model.nfcs.count, model.nfcs.count];
        [self.contentView addSubview:lbl];
        
        UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(25, 16 + 18 + 8 + (userNum+1)*8 + (userNum+1)*17, SCREEN_WIDTH-80, 17)];
        lbl2.font = [UIFont systemFontOfSize:14];
        lbl2.textColor = [UIColor darkGrayColor];
        lbl2.text = [NSString stringWithFormat:@"已上传%zd张照片", model.photos.count];
        [self.contentView addSubview:lbl2];
    }
    
    if (model.nfcs.count == 0 && model.photos.count > 0) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 16 + 18 + 8 + userNum*8 + userNum*17, SCREEN_WIDTH-80, 17)];
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textColor = [UIColor darkGrayColor];
        lbl.text = [NSString stringWithFormat:@"已上传%zd张照片", model.photos.count];
        [self.contentView addSubview:lbl];
    }
}

@end
