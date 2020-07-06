//
//  MaintenanceAuditContentViewController.h
//  dtyios
//
//  Created by Lym on 2020/6/29.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"
@class MaintenanceRecordModel;
NS_ASSUME_NONNULL_BEGIN

@interface MaintenanceAuditContentViewController : YMBaseViewController
@property (nonatomic, copy) NSString *workOrderId;
@property (nonatomic, strong) MaintenanceRecordModel *model;

@end

NS_ASSUME_NONNULL_END
