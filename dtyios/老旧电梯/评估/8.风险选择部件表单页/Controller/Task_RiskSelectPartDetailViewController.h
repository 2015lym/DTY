//
//  Task_RiskSelectPartDetailViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/25.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"
#import "Task_RiskPartModel.h"

@protocol Task_RiskSelectPartDetailViewControllerDelegate <NSObject>

- (void)saveData:(NSMutableArray *)dataArray andIndexPath:(NSIndexPath *)indexPath;

@end

@interface Task_RiskSelectPartDetailViewController : YMBaseViewController

@property (nonatomic, assign) BOOL isPreview;

@property (nonatomic, weak) id<Task_RiskSelectPartDetailViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray<PartAttributeEntityList *> *itemArray;
@property (nonatomic, strong) NSArray<PartAttributeEntityList *> *dataArray;
@property (nonatomic, assign) NSIndexPath *indexPath;

@end
