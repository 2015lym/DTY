//
//  MaintenanceOrderDetailViewController.h
//  dtyios
//
//  Created by Lym on 2020/6/11.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"

typedef NS_ENUM(NSUInteger, OrderType) {
    todo,
    doing,
    checking,
    signing,
    done
};

@interface MaintenanceOrderDetailViewController : YMBaseViewController
@property (nonatomic, assign) OrderType orderType;
@property (nonatomic, copy) NSString *workOrderId;

@end
