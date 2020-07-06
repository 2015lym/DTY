//
//  MaintenanceAuditContentModel.m
//  dtyios
//
//  Created by Lym on 2020/6/30.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceAuditContentModel.h"
#import "MaintenanceContentModel.h"

@implementation UserMaintenanceResult

@end

@implementation MaintenanceAuditContentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"users": @"UserMaintenanceResult",
             @"nfcs": @"MaintenanceWorkRecordNfcs",
             @"photos": @"MaintenanceWorkRecordImgs"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"users": [UserMaintenanceResult class],
             @"nfcs": [AppMaintenanceWorkRecordNfcDtos class],
             @"photos": [AppMaintenanceWorkRecordImgDtos class]
             };
}

@end
