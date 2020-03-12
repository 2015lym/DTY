//
//  Task_PartDetailTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/17.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskPartDetailDelegate.h"
#import "Task_PartModel.h"

@interface Task_PartDetailTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TaskPartDetailDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property (nonatomic, assign) BOOL isPreview;
@property (nonatomic, strong) ElevatorAssessmentItemEntityList *model;
@property (nonatomic, assign) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
