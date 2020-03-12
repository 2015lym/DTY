//
//  Part_WorkListModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/13.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserListModel.h"

@interface Part_WorkListModel : NSObject

@property (nonatomic, assign) NSInteger ClosingMode;
@property (nonatomic, assign) NSInteger PortalCraneDrivingMode;
@property (nonatomic, copy) NSString *InternalNumAndBuildingNum;
@property (nonatomic, assign) NSInteger WireRope;
@property (nonatomic, copy) NSString *ManufacturingUnit;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *ElevatorUsageTime;
@property (nonatomic, strong) NSArray<UserListModel *> *users;
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
@property (nonatomic, assign) NSInteger RatedLoad;
@property (nonatomic, copy) NSString *ElevatorModel;
@property (nonatomic, assign) NSInteger PlaceOfUse;
@property (nonatomic, copy) NSString *FlowStatusActionsId;
@property (nonatomic, copy) NSString *PropertyCompany;
@property (nonatomic, assign) NSInteger AssessmentType;
@property (nonatomic, copy) NSString *TractionRatio;
@property (nonatomic, copy) NSString *InitialInstallationAcceptanceTime;

// 任务状态 123 跟首页一样
@property (nonatomic, assign) NSInteger workStatus;

@end
