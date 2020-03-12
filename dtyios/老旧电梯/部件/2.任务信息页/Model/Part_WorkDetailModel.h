//
//  Part_WorkDetailModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/13.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserListModel.h"

@interface Part_WorkDetailModel : NSObject

/*
 未指派   069abbbf-4a6c-4cce-b353-4cf77db6a9a5
 未进行   de82b5b8-4cb0-4f16-91a5-d36f89ac695f
 进行中   8678a72c-2397-482f-85ad-a3f03db74bfd
 已完成   307ec07f-1fae-4125-88af-11151a0b624e
 */
@property (nonatomic, copy) NSString *FlowStatusActionsId;

@property (nonatomic, assign) NSInteger ClosingMode;
@property (nonatomic, assign) NSInteger PortalCraneDrivingMode;
@property (nonatomic, copy) NSString *InternalNumAndBuildingNum;
@property (nonatomic, assign) NSInteger WireRope;
@property (nonatomic, copy) NSString *ManufacturingUnit;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *ElevatorUsageTime;
@property (nonatomic, copy) NSString *CertificateNum;
@property (nonatomic, assign) NSInteger ElevatorType;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *RatedSpeed;
@property (nonatomic, copy) NSString *MaintenanceCompany;
@property (nonatomic, copy) NSString *CompletionTime;
@property (nonatomic, copy) NSString *MotorPower;
@property (nonatomic, assign) NSInteger IsBreakthrough;
@property (nonatomic, assign) NSInteger DrivingMode;
@property (nonatomic, copy) NSString *ProductNumber;
@property (nonatomic, assign) NSInteger InorganicRoom;
@property (nonatomic, assign) NSInteger OpeningDirection;
@property (nonatomic, copy) NSString *FlowStatusName;
@property (nonatomic, copy) NSString *CommunityDetailedAddress;
@property (nonatomic, copy) NSString *CommunityName;
@property (nonatomic, copy) NSString *LayerStationDoor;
@property (nonatomic, copy) NSString *RatedLoad;
@property (nonatomic, copy) NSString *ElevatorModel;
@property (nonatomic, assign) NSInteger PlaceOfUse;

@property (nonatomic, copy) NSString *PropertyCompany;
@property (nonatomic, assign) NSInteger AssessmentType;
@property (nonatomic, copy) NSString *TractionRatio;
@property (nonatomic, copy) NSString *InitialInstallationAcceptanceTime;

@property (nonatomic, strong) NSArray<UserListModel *> *users;
@property (nonatomic, strong) NSArray<UserListModel *> *adminUsers;

@end

