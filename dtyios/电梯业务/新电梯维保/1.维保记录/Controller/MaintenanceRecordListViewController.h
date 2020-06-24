//
//  MaintenanceRecordListViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"

@interface MaintenanceRecordListViewController : YMBaseViewController
// (1.未进行 2.进行中 3.待审核 4.待签字 5.已完成 6.今日维保 7.超期电梯 8.待审核待签字)
@property (nonatomic, assign) NSInteger workStatus;

@end
