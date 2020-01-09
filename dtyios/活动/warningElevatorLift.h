//
//  warningElevatorLift.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/8.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableItem.h"


 @interface warningElevatorLift : UITableItem
 @property(nonatomic,strong)NSString * BaiduMapXY;
 @property(nonatomic,strong)NSString * BaiduMapZoom;
 @property(nonatomic,strong)NSString * LiftNum ;
 @property(nonatomic,strong)NSString * InstallationAddress ;
 @property(nonatomic,strong)NSString * AddressPath ;

//一个大头针用的
@property(nonatomic,strong)NSString * CertificateNum;
@property(nonatomic,strong)NSString * MachineNum;
@property(nonatomic,strong)NSString * CustomNum;
@property(nonatomic,strong)NSString * Brand;
@property(nonatomic,strong)NSString * Model;
@property(nonatomic,strong)NSString * LiftSiteDict;//使用场所
@property(nonatomic,strong)NSString * LiftTypeDict;//电梯类型
@property(nonatomic,strong)NSString * UseDepartment;//使用单位

@property(nonatomic,strong)NSMutableArray * UseUsers;//管理人员
@property(nonatomic,strong)NSMutableArray *MaintUsers;//维保人员
@property(nonatomic,strong)NSMutableArray *Maint2Users;//二级维保单位
@property(nonatomic,strong)NSMutableArray *Maint3Users;//3级维保单位

@property(nonatomic,strong)NSString * MaintenanceDepartment;//维保单位






 @end
 
