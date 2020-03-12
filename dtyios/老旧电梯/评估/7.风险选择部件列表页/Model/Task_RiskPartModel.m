//
//  Task_RiskPartModel.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/25.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_RiskPartModel.h"

@implementation PartAttributeEntityList

@end

@implementation PartsCategoryEntityList
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"categorykArray": @"PartsCategoryEntityList",
             @"itemArray": @"PartAttributeEntityList"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"categorykArray": [PartsCategoryEntityList class],
             @"itemArray": [PartAttributeEntityList class],
             @"dataArray": [PartAttributeEntityList class],
             };
}

@end

@implementation Task_RiskPartModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"categorykArray": @"PartsCategoryEntityList",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"categorykArray": [PartsCategoryEntityList class]
             };
}


@end
