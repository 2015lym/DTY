//
//  Task_RiskPartSelectTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/25.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task_RiskPartModel.h"

typedef NS_ENUM(NSUInteger, kRiskPartSelectType) {
    kSelect,
    kChanage,
    kDelete,
};

@protocol Task_RiskPartSelectTableViewCellDelegate <NSObject>

- (void)selectAction:(kRiskPartSelectType)type andIndexPath:(NSIndexPath *)indexPath;

@end


@interface Task_RiskPartSelectTableViewCell : UITableViewCell

@property (nonatomic, weak) id<Task_RiskPartSelectTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLeading;


@property (nonatomic, assign) BOOL isPreview;
@property (nonatomic, strong) PartsCategoryEntityList *model;
@property (nonatomic, assign) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end

