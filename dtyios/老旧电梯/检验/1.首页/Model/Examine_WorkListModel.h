//
//  Examine_WorkListModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/13.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Examine_WorkListModel : NSObject

@property (nonatomic, copy) NSString *CompletionTime;
@property (nonatomic, copy) NSString *CertificateNum;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *CommunityDetailedAddress;
@property (nonatomic, copy) NSString *CommunityName;
@property (nonatomic, strong) NSArray<NSString *> *UserNameList;
@property (nonatomic, copy) NSString *ElevatorUsageTime;
@property (nonatomic, copy) NSString *FlowStatusActionsId;
@property (nonatomic, copy) NSString *Id;

// 任务状态 123 跟首页一样
@property (nonatomic, assign) NSInteger workStatus;
@end
