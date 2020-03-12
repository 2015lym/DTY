//
//  Examine_SubmitViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/27.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"
#import "Part_WorkDetailModel.h"

@interface Examine_SubmitViewController : YMBaseViewController

@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, strong) Part_WorkDetailModel *work;

@end
