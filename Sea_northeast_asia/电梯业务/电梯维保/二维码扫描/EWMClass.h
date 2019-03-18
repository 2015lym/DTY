//
//  EWMClass.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/4/5.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EWMClass : NSObject

@property (nonatomic,strong) NSString *CheckDetailId;
@property (nonatomic,strong) NSString *CheckId;
@property (nonatomic,strong) NSString *CheckDate;
@property (nonatomic,strong) NSString *UploadDate;
@property (nonatomic) BOOL IsPassed;
@property (nonatomic,strong) NSString *Remark;
@property (nonatomic,strong) NSString *Photo;
@property (nonatomic,strong) NSString *LongitudeAndLatitude;
@property (nonatomic,strong) NSString *StepId;
@property (nonatomic,strong) NSString *UserId;
@property (nonatomic,strong) NSString *DeptId;
@property (nonatomic,strong) NSString *LiftId;
@property (nonatomic,strong) NSString *CType;

@property (nonatomic,strong) NSString *NFCCode;
@property (nonatomic,strong) NSString *ID;
@end
