//
//  Old_PartListTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/12.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Part_PreviewModel.h"

@protocol Old_PartListTableViewCellDelegate <NSObject>

- (void)clearActionIndex:(NSIndexPath *)indexPath;

- (void)unfoldAction:(BOOL)isUnfold andIndex:(NSIndexPath *)indexPath;

@end


@interface Old_PartListTableViewCell : UITableViewCell

@property (nonatomic, weak) id<Old_PartListTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *unfoldButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property (nonatomic, assign) NSIndexPath *indexPath;

@property (nonatomic, assign) BOOL isPreview;

@property (nonatomic, strong) Part_PreviewModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
