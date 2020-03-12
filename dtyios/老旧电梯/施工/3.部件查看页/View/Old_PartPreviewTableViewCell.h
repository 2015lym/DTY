//
//  Old_PartPreviewTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/11.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Part_PreviewModel.h"

@interface Old_PartPreviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) Part_PreviewModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
