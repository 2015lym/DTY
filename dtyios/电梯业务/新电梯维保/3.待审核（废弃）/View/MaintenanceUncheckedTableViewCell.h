//
//  MaintenanceUncheckedTableViewCell.h
//  dtyios
//
//  Created by Lym on 2020/6/10.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MaintenanceUncheckedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end

NS_ASSUME_NONNULL_END
