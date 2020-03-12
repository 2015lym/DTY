//
//  Task_RiskSelectPartViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/24.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"

@protocol Task_RiskSelectPartViewControllerDelegate <NSObject>

- (void)reloadTableViewAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface Task_RiskSelectPartViewController : YMBaseViewController

@property (nonatomic, assign) BOOL isPreview;


@property (nonatomic, weak) id<Task_RiskSelectPartViewControllerDelegate> delegate;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *itemId;

@property (nonatomic, strong) NSMutableArray *lastArray;

@end
