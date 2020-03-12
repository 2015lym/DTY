//
//  Part_WorkDetailModel.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/13.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Part_WorkDetailModel.h"

@implementation Part_WorkDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"users": @"TaskUserSignEntityList",
             @"adminUsers": @"ComponentAdministratorEntityList"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"users": [UserListModel class],
             @"adminUsers": [UserListModel class]
             };
}


@end
