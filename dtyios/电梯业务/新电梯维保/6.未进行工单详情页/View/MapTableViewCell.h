//
//  MapTableViewCell.h
//  dtyios
//
//  Created by Lym on 2020/6/12.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) BMKMapView *mapView;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end

NS_ASSUME_NONNULL_END
