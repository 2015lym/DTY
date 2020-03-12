//
//  Examine_ProjectListTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/27.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamineProjectListModel.h"

@protocol Examine_ProjectListTableViewCellDelegate <NSObject>

- (void)clearActionIndex:(NSIndexPath *)indexPath;

@end


@interface Examine_ProjectListTableViewCell : UITableViewCell

@property (nonatomic, weak) id<Examine_ProjectListTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;

@property (nonatomic, assign) NSIndexPath *indexPath;

@property (nonatomic, assign) BOOL isPreview;

@property (nonatomic, strong) ExamineProjectListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
