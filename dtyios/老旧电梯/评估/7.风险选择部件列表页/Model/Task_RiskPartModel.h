//
//  Task_RiskPartModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/25.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartAttributeEntityList: NSObject
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *SortCode;
@property (nonatomic, copy) NSString *PartAttributeName;
@property (nonatomic, copy) NSString *DataType;
@property (nonatomic, copy) NSString *PartCategoryId;
@property (nonatomic, copy) NSString *PartAttributeValue;
@property (nonatomic, copy) NSString *NewPartAttributeValue;
@property (nonatomic, copy) NSString *PartAttributeUnit;
@property (nonatomic, copy) NSString *ElevatorPartRecordId;

@property (nonatomic, copy) NSString *PartName;
@property (nonatomic, assign) BOOL isLocal;

@end

@interface PartsCategoryEntityList: NSObject
@property (nonatomic, assign) NSInteger SortCode;
@property (nonatomic, copy) NSString *VarietyCode;
@property (nonatomic, copy) NSString *ParentId;
@property (nonatomic, copy) NSString *CategoryName;
@property (nonatomic, copy) NSString *AssessmentItemName;
@property (nonatomic, copy) NSString *AssessmentItemRequirement;
@property (nonatomic, assign) NSInteger CategoryLevel;
@property (nonatomic, strong) NSArray<PartsCategoryEntityList *> *categorykArray;
@property (nonatomic, strong) NSArray<PartAttributeEntityList *> *itemArray;
@property (nonatomic, strong) NSArray<PartAttributeEntityList *> *dataArray;
@property (nonatomic, copy) NSString *Id;

@property (nonatomic, assign) BOOL hasValue;

@end

@interface Task_RiskPartModel : NSObject
@property (nonatomic, copy) NSString *CertificateNum;
@property (nonatomic, copy) NSString *TaskId;
@property (nonatomic, copy) NSString *InternalNumAndBuildingNum;
@property (nonatomic, strong) NSArray<PartsCategoryEntityList *> *categorykArray;

@end
