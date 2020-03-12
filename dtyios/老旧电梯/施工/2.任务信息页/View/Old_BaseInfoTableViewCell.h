//
//  Old_BaseInfoTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Part_WorkDetailModel.h"
#import "Task_WorkDetailModel.h"

@interface Old_BaseInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *installTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *useCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *repaireCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;

@property (nonatomic, strong) Part_WorkDetailModel *model;
@property (nonatomic, strong) Task_WorkDetailModel *envModel;


+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
