//
//  Part_PreviewModel.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/14.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Part_PreviewModel.h"

@implementation Part_PreviewModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"entityArray": @"PartAttributeEntityList",
             @"parts": @"ConstructionElevatorPartEntityList",
             @"images": @"ConstructionContrastRecordEntityList",
             @"remarks": @"ConstructionNoteRecordEntityList"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"entityArray": [PartAttributeEntityListModel class],
             @"parts": [BindPartModel class],
             @"images": [OldImageModel class],
             @"remarks": [OldRemarkModel class]
             };
}

@end
