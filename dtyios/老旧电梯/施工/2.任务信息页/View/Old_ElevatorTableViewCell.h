//
//  Old_ElevatorTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Part_WorkDetailModel.h"
#import "Task_WorkDetailModel.h"

@interface Old_ElevatorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *layerStationDoorLabel;
@property (weak, nonatomic) IBOutlet UILabel *tractionRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratedSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *drivingModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *inorganicRoomLabel;
@property (weak, nonatomic) IBOutlet UILabel *motorPowerLabel;

@property (weak, nonatomic) IBOutlet UILabel *openingDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *wireRopeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratedLoadLabel;
@property (weak, nonatomic) IBOutlet UILabel *portalCraneDrivingModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *closingModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *isBreakthroughLabel;

@property (nonatomic, strong) Part_WorkDetailModel *model;
@property (nonatomic, strong) Task_WorkDetailModel *envModel;


+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
