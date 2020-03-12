//
//  Task_WorkListModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/5.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task_WorkListModel : NSObject
@property (nonatomic, assign) NSInteger PortalCraneDrivingMode;
@property (nonatomic, assign) NSInteger ClosingMode;
@property (nonatomic, copy) NSString *InternalNumAndBuildingNum;
@property (nonatomic, assign) NSInteger WireRope;
@property (nonatomic, copy) NSString *ManufacturingUnit;
@property (nonatomic, copy) NSString *TaskUserSignEntityList;
@property (nonatomic, copy) NSString *ElevatorUsageTime;
@property (nonatomic, copy) NSString *CertificateNum;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, assign) NSInteger ElevatorType;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *RatedSpeed;
@property (nonatomic, copy) NSString *MaintenanceCompany;
@property (nonatomic, copy) NSString *CompletionTime;
@property (nonatomic, copy) NSString *MotorPower;
@property (nonatomic, assign) NSInteger DrivingMode;
@property (nonatomic, assign) NSInteger IsBreakthrough;
@property (nonatomic, copy) NSString *ProductNumber;
@property (nonatomic, assign) NSInteger InorganicRoom;
@property (nonatomic, assign) NSInteger OpeningDirection;
@property (nonatomic, copy) NSString *InitialInstallationAcceptanceTime1;
@property (nonatomic, assign) BOOL IsCompleteRiskComponent;
@property (nonatomic, copy) NSString *CommunityDetailedAddress;
@property (nonatomic, copy) NSString *CommunityName;
@property (nonatomic, copy) NSString *LayerStationDoor;
@property (nonatomic, assign) NSInteger RatedLoad;
@property (nonatomic, copy) NSString *ElevatorModel;
@property (nonatomic, assign) BOOL IsCompletePartAssessment;
@property (nonatomic, assign) NSInteger PlaceOfUse;
@property (nonatomic, copy) NSString *FlowStatusActionsId;
@property (nonatomic, copy) NSString *PropertyCompany;
@property (nonatomic, copy) NSString *InitialInstallationAcceptanceTime;
@property (nonatomic, assign) NSInteger AssessmentType;
@property (nonatomic, copy) NSString *TractionRatio;

// 任务状态 123 跟首页一样
@property (nonatomic, assign) NSInteger workStatus;
@end
