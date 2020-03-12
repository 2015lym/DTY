//
//  Task_SubmitViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/27.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"
#import "Task_PartModel.h"

@interface Task_SubmitViewController : YMBaseViewController

@property (nonatomic, strong) Task_PartModel *model;
@property (nonatomic, copy) NSString *communityDetailedAddress;

@end
