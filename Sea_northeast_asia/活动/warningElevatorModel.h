//
//  CurriculumEntity.h
//  AlumniChat
//
//  Created by SongQues on 16/7/1.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "UITableItem.h"

#import "warningElevatorLift.h"

@interface warningElevatorModel : UITableItem

@property(nonatomic,strong)warningElevatorLift *Lift;
@property(nonatomic,strong)NSString * CreateTime;
@property(nonatomic,strong)NSString * ID;
@property(nonatomic,strong)NSString * LiftId;
@property(nonatomic,strong)NSString * StatusId ;
@property(nonatomic,strong)NSString * StatusName ;
@property(nonatomic,strong)NSString * RescueType;
@property(nonatomic,strong)NSString * TotalLossTime;


//选择一个大头针
@property(nonatomic,strong)NSString * UseConfirmTime;
@property(nonatomic,strong)NSString * SourceDict;//任务来源

@property(nonatomic,strong)NSString * RescueNumber;//被困人数
@property(nonatomic,strong)NSString * RescuePhone;//联系电话
@property(nonatomic,strong)NSString * Content;//任务备注
@property(nonatomic,strong)NSString * ReasonId;
@property(nonatomic,strong)NSString * ReasonDesc;
@property(nonatomic,strong)NSString * RemedyId;
@property(nonatomic,strong)NSString * RemedyDesc;

@property(nonatomic,strong)NSString * RemedyUserId;//救援人员
@property(nonatomic,strong)NSString * RemedyUser;//救援人员
@property(nonatomic,strong)NSString * RemedyUserPhone;//救援人员phone

@property(nonatomic,strong)NSString * MaintConfirmTime;//接单时间
@property(nonatomic,strong)NSString * RescueCompleteTime;//完成时间
@property(nonatomic,strong)NSString * ConfirmUserId;


//
@property(nonatomic,strong)NSString * MaintArriveTime;//维保到场时间
@property(nonatomic,strong)NSString * RemedyUserDeptName;//救援人员所属公司
@property(nonatomic,strong)NSString * ReasonDict;//故障原因
@property(nonatomic,strong)NSString * RemedyDict;//救援方法

@property (nonatomic,strong) NSString *YearInspectionDate;
@property (nonatomic,strong) NSString *YearInspectionNextDate;


@end
