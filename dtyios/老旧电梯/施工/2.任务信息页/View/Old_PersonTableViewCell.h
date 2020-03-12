//
//  Old_PersonTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Part_WorkDetailModel.h"

@interface Old_PersonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peopleViewHeight;
@property (weak, nonatomic) IBOutlet UIView *peopleView;

@property (nonatomic, strong) Part_WorkDetailModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
