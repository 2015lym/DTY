//
//  BindPartModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/14.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindPartModel : NSObject

/* TaskId */
@property (nonatomic, copy) NSString *TaskManageId;
/* ElevatorPartRecordId */
@property (nonatomic, copy) NSString *GzElevatorPartRecordId;
/* 二维码 */
@property (nonatomic, copy) NSString *QRCode;
/* NFC码 */
@property (nonatomic, copy) NSString *NfcNumber;
/* 唯一标识 */
@property (nonatomic, copy) NSString *ProductNumber;

- (instancetype)initWithTaskId:(NSString *)taskId andElevatorPartRecordId:(NSString *)partId;

@end
