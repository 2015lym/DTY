//
//  BindPartModel.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/14.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "BindPartModel.h"

@implementation BindPartModel

- (instancetype)initWithTaskId:(NSString *)taskId andElevatorPartRecordId:(NSString *)partId {
    self = [super init];
    if (self) {
        _TaskManageId = taskId;
        _GzElevatorPartRecordId = partId;
        _ProductNumber = @"";
        _NfcNumber = @"";
        _QRCode = @"";
    }
    return self;
}

@end
