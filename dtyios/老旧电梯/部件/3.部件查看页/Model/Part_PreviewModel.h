//
//  Part_PreviewModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/14.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartAttributeEntityListModel.h"
#import "BindPartModel.h"
#import "OldRemarkModel.h"
#import "OldImageModel.h"

@interface Part_PreviewModel : NSObject
@property (nonatomic, copy) NSString *InternalNumAndBuildingNum;
@property (nonatomic, copy) NSString *FlowStatusName;

// 列表内容
@property (nonatomic, strong) NSArray<PartAttributeEntityListModel *> *entityArray;
// 绑定的
@property (nonatomic, strong) NSArray<BindPartModel *> *parts;
// 图
@property (nonatomic, strong) NSArray<OldImageModel *> *images;
// 备注
@property (nonatomic, strong) NSArray<OldRemarkModel *> *remarks;

@property (nonatomic, copy) NSString *CertificateNum;
@property (nonatomic, copy) NSString *RemarksParts;
@property (nonatomic, copy) NSString *PartName;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *ModifyUserId;
@property (nonatomic, copy) NSString *TaskManageId;
@property (nonatomic, copy) NSString *FlowStatusActionsId;
@property (nonatomic, copy) NSString *ReturnReason;
@property (nonatomic, copy) NSString *CategoryId;


// 本地部件数据
@property (nonatomic, assign) BOOL localBind;

// 本地施工数据
@property (nonatomic, assign) BOOL localRemark;
// 本地施工数据
@property (nonatomic, assign) BOOL netRemark;

// 展开
@property (nonatomic, assign) BOOL isUnfold;

// 任务已完成
@property (nonatomic, assign) BOOL isComplete;

@end
