//
//  Part_WorkListModel.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/13.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Part_WorkListModel.h"

@implementation Part_WorkListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"users": @"TaskUserSignEntityList"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"users": [UserListModel class]};
}

@end
