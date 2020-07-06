//
//  MaintenanceNFCListTableViewCell.h
//  dtyios
//
//  Created by Lym on 2020/7/3.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppMaintenanceWorkRecordNfcDtos;

@interface MaintenanceNFCListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *recognitionLabel;
@property (weak, nonatomic) IBOutlet UILabel *nfcIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *nfcNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, strong) AppMaintenanceWorkRecordNfcDtos *model;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
