//
//  Env_FormModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/11.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvironmentAssessmentItmeEntity: NSObject
@property (nonatomic, copy) NSString *SortCode;
@property (nonatomic, copy) NSString *ItemUnit;
@property (nonatomic, copy) NSString *DataItemValue;
@property (nonatomic, copy) NSString *ItemTitle;
@property (nonatomic, copy) NSString *AssessmentCategoryId;
@property (nonatomic, copy) NSString *ItemValue;
@property (nonatomic, copy) NSString *Id;

@end

@interface EnvironmentAssessmentCategoryEntityList: NSObject
@property (nonatomic, assign) NSInteger SortCode;
@property (nonatomic, copy) NSString *ParentId;
@property (nonatomic, copy) NSString *ControlType;
@property (nonatomic, strong) NSArray<EnvironmentAssessmentItmeEntity *> *valueArray;
@property (nonatomic, assign) NSInteger CategoryLevel;
@property (nonatomic, copy) NSString *CategoryName;
@property (nonatomic, copy) NSString *Id;

// 值
@property (nonatomic, copy) NSString *value;

@end

@interface EnvironmentAssessmentCategoryParentEntityList: NSObject
@property (nonatomic, copy) NSString *CategoryName;
@property (nonatomic, strong) NSArray<EnvironmentAssessmentCategoryEntityList *> *itemArray;
@property (nonatomic, copy) NSString *ParentId;
@property (nonatomic, assign) NSInteger SortCode;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, assign) NSInteger CategoryLevel;
@end


@interface Env_FormModel : NSObject
@property (nonatomic, copy) NSString *CommunityDetailedAddress;
@property (nonatomic, copy) NSString *CommunityName;
@property (nonatomic, strong) NSArray<EnvironmentAssessmentCategoryParentEntityList *> *categoryArray;
@property (nonatomic, copy) NSString *MaintenanceId;

@end
