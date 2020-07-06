//
//  MaintenanceContentModel.m
//  dtyios
//
//  Created by Lym on 2020/6/24.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceContentModel.h"

@implementation AppMaintenanceWorkRecordImgDtos

@end

@implementation AppMaintenanceWorkRecordNfcDtos

@end

@implementation AppMaintenanceUserSignDto

@end

@implementation AppMaintenanceItemDtos
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"nfcs": @"AppMaintenanceWorkRecordNfcDtos",
             @"photos": @"AppMaintenanceWorkRecordImgDtos"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"nfcs": [AppMaintenanceWorkRecordNfcDtos class],
             @"photos": [AppMaintenanceWorkRecordImgDtos class]
             };
}

@end

@implementation AppMaintenanceWorkResultDtos

@end


@implementation MaintenanceContentModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"itemArray": @"AppMaintenanceItemDtos",
             @"resultArray": @"AppMaintenanceWorkResultDtos",
             @"userSign": @"AppMaintenanceUserSignDto",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"itemArray": [AppMaintenanceItemDtos class],
             @"resultArray": [AppMaintenanceWorkResultDtos class],
             @"userSign": [AppMaintenanceUserSignDto class],
             };
}

@end
