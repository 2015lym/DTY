//
//  Examine_ProjectListViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/26.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"
#import "Part_WorkDetailModel.h"

@interface Examine_ProjectListViewController : YMBaseViewController

@property (nonatomic, strong) Part_WorkDetailModel *work;

@property (nonatomic, copy) NSString *taskId;

@property (nonatomic, assign) BOOL isPreview;
@end
