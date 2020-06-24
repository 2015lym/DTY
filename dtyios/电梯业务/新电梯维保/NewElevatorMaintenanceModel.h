//
//  NewElevatorMaintenanceModel.h
//  dtyios
//
//  Created by Lym on 2020/6/17.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewElevatorMaintenanceModel : NSObject
@property (nonatomic, assign) NSInteger Completed;
@property (nonatomic, assign) NSInteger PendingReview;
@property (nonatomic, assign) NSInteger OverdueElevator;
@property (nonatomic, assign) NSInteger MaintenanceToday;

@end
