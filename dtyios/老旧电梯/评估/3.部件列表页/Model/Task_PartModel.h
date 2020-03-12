//
//  Task_PartModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/15.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

// 备注
@interface ElevatorAssessmentPartRecordEntityList: NSObject
/* TaskId */
@property (nonatomic, copy) NSString *TaskId;
/* 备注类型 */
@property (nonatomic, copy) NSString *DataType;
/* 备注值 */
@property (nonatomic, copy) NSString *DataValue;


@property (nonatomic, copy) NSString *CertificateNum;
@property (nonatomic, copy) NSString *InternalNumAndBuildingNum;
@property (nonatomic, copy) NSString *AssessmentClassId;
@property (nonatomic, copy) NSString *AssessmentClassName;
@property (nonatomic, copy) NSString *AssessmentPartId;
@property (nonatomic, copy) NSString *AssessmentPartName;

@end


// 最后一级选项
@interface ElevatorAssessmentItemEntityList: NSObject
@property (nonatomic, copy) NSString *Requirement;
@property (nonatomic, copy) NSString *ProbabilityLevel;
@property (nonatomic, copy) NSString *RiskCategoriesValue;
@property (nonatomic, copy) NSString *Solution;
@property (nonatomic, copy) NSString *RiskCategories;
@property (nonatomic, assign) NSInteger SortCode;
@property (nonatomic, copy) NSString *PartCreateUserId;
@property (nonatomic, copy) NSString *SeverityLevel;
@property (nonatomic, copy) NSString *PartId;
@property (nonatomic, copy) NSString *IdentificationStatus;
@property (nonatomic, copy) NSString *ItemName;
@property (nonatomic, copy) NSString *RiskDescription;
@property (nonatomic, copy) NSString *ItemId;
@property (nonatomic, assign) BOOL IsReform;
@property (nonatomic, copy) NSString *CreateUserId;

// 是否是标题
@property (nonatomic, assign) BOOL isTitle;

@end

@interface ElevatorAssessmentPartEntityList: NSObject
@property (nonatomic, copy) NSString *AssessmentClassId;
@property (nonatomic, copy) NSString *PartId;
@property (nonatomic, assign) NSInteger SortCode;
@property (nonatomic, strong) NSArray<ElevatorAssessmentItemEntityList *> *itemArray;
@property (nonatomic, strong) NSArray<ElevatorAssessmentPartRecordEntityList *> *remarkArray;
@property (nonatomic, assign) BOOL IsReform;
@property (nonatomic, copy) NSString *PartName;

@end

@interface ElevatorAssessmentClassEntityList: NSObject
@property (nonatomic, assign) NSInteger SortCode;
@property (nonatomic, assign) BOOL IsRiskComponent;
@property (nonatomic, strong) NSArray<ElevatorAssessmentPartEntityList *> *partArray;
@property (nonatomic, copy) NSString *ClassName;
@property (nonatomic, copy) NSString *ClassId;

@end


@interface Task_PartModel : NSObject
@property (nonatomic, copy) NSString *ElevatorRiskLevel;
@property (nonatomic, copy) NSString *InternalNumAndBuildingNum;
@property (nonatomic, assign) NSInteger SecondaryRiskProjectsNum;
@property (nonatomic, copy) NSString *QRCode;
@property (nonatomic, copy) NSString *CertificateNum;
@property (nonatomic, copy) NSString *TaskId;
@property (nonatomic, assign) NSInteger TertiaryRiskProjectNum;
@property (nonatomic, assign) NSInteger PrimaryRiskProjectNum;
@property (nonatomic, strong) NSArray<ElevatorAssessmentClassEntityList *> *classArray;

@end
