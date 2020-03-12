//
//  Task_RiskPartDetailTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/17.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task_PartModel.h"
#import "RiskTaskPartDetailDelegate.h"

@interface Task_RiskPartDetailTableViewCell : UITableViewCell

@property (nonatomic, weak) id<RiskTaskPartDetailDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UILabel *severityLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *probabilityLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *riskCategoriesLabel;


@property (weak, nonatomic) IBOutlet UILabel *riskDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *solutionLabel;
@property (weak, nonatomic) IBOutlet UILabel *partInfoLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, strong) ElevatorAssessmentItemEntityList *model;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableArray *nextPartArray;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
