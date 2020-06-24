//
//  MapTableViewCell.m
//  dtyios
//
//  Created by Lym on 2020/6/12.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MapTableViewCell.h"
#import "Masonry.h"

@implementation MapTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _mapView = [[BMKMapView alloc] init];
    _mapView.zoomLevel = 14;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(41.74777698042053, 123.40173256281172);
    [self.contentView addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-16);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"MapTableViewCell";
    MapTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (MapTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}
@end
