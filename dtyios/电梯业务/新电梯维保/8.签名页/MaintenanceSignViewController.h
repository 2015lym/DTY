//
//  MaintenanceSignViewController.h
//  dtyios
//
//  Created by Lym on 2020/6/26.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"
#import "MaintenanceContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MaintenanceSignViewController : YMBaseViewController
@property (nonatomic, strong) MaintenanceContentModel *maintenanceModel;

@property (nonatomic, assign) BOOL isCheck;
@property (nonatomic, copy) NSString *workOrderId;


@end

NS_ASSUME_NONNULL_END
