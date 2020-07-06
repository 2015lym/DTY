//
//  MaintenanceAuditContentModel.h
//  dtyios
//
//  Created by Lym on 2020/6/30.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppMaintenanceWorkRecordImgDtos, AppMaintenanceWorkRecordNfcDtos;

@interface UserMaintenanceResult: NSObject
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *ResultName;
@property (nonatomic, assign) NSInteger MaintenanceWorkResultsId;
@property (nonatomic, assign) NSInteger CreateUserId;
@end

@interface MaintenanceAuditContentModel : NSObject
@property (nonatomic, strong) NSArray<UserMaintenanceResult *> *users;
@property (nonatomic, strong) NSArray<AppMaintenanceWorkRecordNfcDtos *> *nfcs;
@property (nonatomic, strong) NSArray<AppMaintenanceWorkRecordImgDtos *> *photos;

@property (nonatomic, assign) NSInteger MaintenanceItemId;
@property (nonatomic, assign) NSInteger WorkRecordId;
@property (nonatomic, copy) NSString *MaintenanceItemName;
@property (nonatomic, copy) NSString *MaintenanceItemDesc;

@end
