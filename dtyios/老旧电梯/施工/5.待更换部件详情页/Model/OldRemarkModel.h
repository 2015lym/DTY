//
//  OldRemarkModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/20.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OldRemarkModel : NSObject

/* TaskId */
@property (nonatomic, copy) NSString *TaskManageId;
/* ElevatorPartRecordId */
@property (nonatomic, copy) NSString *GzElevatorPartRecordId;
/* 备注类型 */
@property (nonatomic, copy) NSString *DataType;
/* 备注值 */
@property (nonatomic, copy) NSString *DataValue;

@end
