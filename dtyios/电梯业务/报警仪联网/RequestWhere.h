//
//  RequestWhere.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/12/27.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestWhere : NSObject
@property(nonatomic)int  CityId;
@property(nonatomic)int  AddressId;
@property(nonatomic)int  IsInstallation;
@property(nonatomic)int  IsOnline;
@property(nonatomic)int  MaintDeptId;
@property(nonatomic)int  UseDeptId;

@property(nonatomic)int  IsShield; //屏蔽状态
@property(nonatomic)int  ShieldReasonId;//屏蔽原因
@end
