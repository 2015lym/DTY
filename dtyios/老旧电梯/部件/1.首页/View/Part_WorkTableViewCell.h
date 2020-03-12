//
//  Part_WorkTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/5.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Part_WorkListModel.h"

@protocol Part_WorkTableViewCellDelegate <NSObject>

- (void)outAction:(Part_WorkListModel *)model;

@end

@interface Part_WorkTableViewCell : UITableViewCell

@property (nonatomic, weak) id<Part_WorkTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *elevatorNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIButton *outButton;

@property (nonatomic, strong) Part_WorkListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
