//
//  MaintenanceRecordModel.h
//  dtyios
//
//  Created by Lym on 2020/6/17.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MaintenanceRecordModel : NSObject

@property (nonatomic, copy) NSString *PlanMaintenanceTime;
@property (nonatomic, strong) NSArray<NSDictionary *> *MaintenanceUserNameList;
@property (nonatomic, copy) NSString *BeginMaintenanceTime;
@property (nonatomic, copy) NSString *CertificateNum;
@property (nonatomic, copy) NSString *DetailAddress;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger LiftId;
@property (nonatomic, copy) NSString *WorkOrderStatusName;
@property (nonatomic, assign) BOOL IsClose;
@property (nonatomic, copy) NSString *AddressPath;
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, copy) NSString *CompleteMaintenanceTime;
@property (nonatomic, copy) NSString *ParkName;
@property (nonatomic, copy) NSString *MaintenanceDate;
@property (nonatomic, copy) NSString *TypeName;
// 1.未进行 2.进行中 3.待审核 4.待签字 5.已完成
@property (nonatomic, assign) NSInteger MaintenanceWorkOrderStatusId;

@property (nonatomic, copy) NSString *MaintenanceTypeId;
@property (nonatomic, copy) NSString *UseDeptName;
@property (nonatomic, copy) NSString *MaintDeptName;

@property (nonatomic, copy) NSString *SupervisorSignImgUrl;
@property (nonatomic, copy) NSString *SignImgUrl;

@property (nonatomic, assign) float Latitude;
@property (nonatomic, assign) float Longitude;


// 自定义参数 (1.未进行 2.进行中 3.待审核 4.待签字 5.已完成 6.今日维保 7.超期电梯 8.待审核待签字)
@property (nonatomic, assign) NSInteger workStatus;

@end

NS_ASSUME_NONNULL_END
