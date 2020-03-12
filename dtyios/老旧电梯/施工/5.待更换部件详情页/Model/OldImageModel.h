//
//  OldImageModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/19.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OldImageModel : NSObject

/* TaskId */
@property (nonatomic, copy) NSString *TaskManageId;
/* ElevatorPartRecordId */
@property (nonatomic, copy) NSString *GzElevatorPartRecordId;
/* 图片路径 */
@property (nonatomic, copy) NSString *ImageUrl;
/* 更换前/更换后 */
@property (nonatomic, assign) BOOL IsBeforeReplacement;

@end
