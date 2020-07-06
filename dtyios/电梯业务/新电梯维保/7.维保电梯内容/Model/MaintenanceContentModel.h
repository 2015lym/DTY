//
//  MaintenanceContentModel.h
//  dtyios
//
//  Created by Lym on 2020/6/24.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppMaintenanceWorkRecordImgDtos: NSObject
@property (nonatomic, copy) NSString *ImgUrl;
@property (nonatomic, copy) NSString *MaintenanceUserId;
@property (nonatomic, copy) NSString *Remark;

@end


@interface AppMaintenanceWorkRecordNfcDtos: NSObject
@property (nonatomic, copy) NSString *ElevatorPartNFCId;
@property (nonatomic, copy) NSString *ElevatorPartNFCIdValue;
@property (nonatomic, copy) NSString *MaintenanceUserId;
@property (nonatomic, copy) NSString *NFCCode;
@property (nonatomic, copy) NSString *NFCNum;
@property (nonatomic, copy) NSString *ElevatorPartBrand;
@property (nonatomic, copy) NSString *ElevatorPartModel;
@property (nonatomic, copy) NSString *ElevatorPartFactoryDate;
@property (nonatomic, copy) NSString *LiftId;
@property (nonatomic, copy) NSString *ElevatorPartsId;
@property (nonatomic, copy) NSString *MaintenanceItemId;
@property (nonatomic, copy) NSString *PartName;
@property (nonatomic, copy) NSString *PhotoUrl;
@property (nonatomic, copy) NSString *Remark;

@end

@interface AppMaintenanceUserSignDto: NSObject
@property (nonatomic, copy) NSString *UserSign;
@property (nonatomic, copy) NSString *UserId;

@end

@interface AppMaintenanceItemDtos: NSObject
@property (nonatomic, copy) NSString *MaintenanceItemName;
@property (nonatomic, assign) NSInteger WorkRecordId;
@property (nonatomic, assign) NSInteger ResultId;
@property (nonatomic, assign) float Longitude;
@property (nonatomic, assign) BOOL IsNFC;
@property (nonatomic, assign) BOOL IsPhoto;
@property (nonatomic, copy) NSString *ResultName;
@property (nonatomic, copy) NSString *MaintenanceItemDesc;
@property (nonatomic, assign) float Latitude;
@property (nonatomic, copy) NSString *MaintenanceUserId;
@property (nonatomic, copy) NSString *ItemId;
@property (nonatomic, strong) NSMutableArray<AppMaintenanceWorkRecordImgDtos *> *photos;
@property (nonatomic, strong) NSMutableArray<AppMaintenanceWorkRecordNfcDtos *> *nfcs;

@end

@interface AppMaintenanceWorkResultDtos: NSObject
@property (nonatomic, copy) NSString *ResultName;
@property (nonatomic, assign) NSInteger Sort;
@property (nonatomic, assign) NSInteger WorkResultId;

@end


@interface MaintenanceContentModel : NSObject
@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *LiftId;
@property (nonatomic, strong) NSMutableArray<AppMaintenanceItemDtos *> *itemArray;
@property (nonatomic, copy) NSString *Latitude;
@property (nonatomic, strong) NSMutableArray<AppMaintenanceWorkResultDtos *> *resultArray;
@property (nonatomic, copy) NSString *Longitude;
@property (nonatomic, assign) NSInteger WorkOrderId;
@property (nonatomic, strong) AppMaintenanceUserSignDto *userSign;
@property (nonatomic, strong) NSMutableArray *AppMaintenanceWorkOrderRemarkDtos;
@end
