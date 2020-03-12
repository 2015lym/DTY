//
//  Env_FormModel.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/11.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Env_FormModel.h"

@implementation EnvironmentAssessmentItmeEntity

@end

@implementation EnvironmentAssessmentCategoryEntityList
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"valueArray": @"EnvironmentAssessmentItmeEntity"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"valueArray": [EnvironmentAssessmentItmeEntity class]
             };
}

@end

@implementation EnvironmentAssessmentCategoryParentEntityList
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"itemArray": @"EnvironmentAssessmentCategoryEntityList"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"itemArray": [EnvironmentAssessmentCategoryEntityList class]
             };
}

@end

@implementation Env_FormModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"categoryArray": @"EnvironmentAssessmentCategoryParentEntityList"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"categoryArray": [EnvironmentAssessmentCategoryParentEntityList class]
             };
}

@end
