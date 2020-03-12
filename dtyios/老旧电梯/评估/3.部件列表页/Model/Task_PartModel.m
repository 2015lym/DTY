//
//  Task_PartModel.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/15.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_PartModel.h"

@implementation ElevatorAssessmentPartRecordEntityList


@end

@implementation ElevatorAssessmentItemEntityList

@end


@implementation ElevatorAssessmentPartEntityList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"itemArray": @"ElevatorAssessmentItemEntityList",
             @"remarkArray": @"ElevatorAssessmentPartRecordEntityList",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"itemArray": [ElevatorAssessmentItemEntityList class],
             @"remarkArray": [ElevatorAssessmentPartRecordEntityList class]
             };
}

@end


@implementation ElevatorAssessmentClassEntityList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"partArray": @"ElevatorAssessmentPartEntityList"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"partArray": [ElevatorAssessmentPartEntityList class]
             };
}

@end


@implementation Task_PartModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"classArray": @"ElevatorAssessmentClassEntityList"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"classArray": [ElevatorAssessmentClassEntityList class]
             };
}

@end
