//
//  MaintenanceContentViewController.h
//  dtyios
//
//  Created by Lym on 2020/6/24.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MaintenanceContentViewController : YMBaseViewController
@property (nonatomic, copy) NSString *workOrderId;
@property (nonatomic, copy) NSString *maintenanceTypeId;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *address;


@property (nonatomic, assign) BOOL isPreview;

@end

NS_ASSUME_NONNULL_END
