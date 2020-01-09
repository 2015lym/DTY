//
//  WYXCClass.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/4/25.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYXCClass : NSObject
@property (nonatomic,strong) NSString *PropertyCheckId;
//@property (nonatomic,strong) NSString *CheckId;
@property (nonatomic,strong) NSString *CheckDate;
//@property (nonatomic,strong) NSString *UploadDate;
@property (nonatomic) BOOL IsPassed;
@property (nonatomic,strong) NSString *Remark;
@property (nonatomic,strong) NSString *Photo;
@property (nonatomic,strong) NSString *PhotoUrl;
@property (nonatomic,strong) NSString *LongitudeAndLatitude;
@property (nonatomic,strong) NSString *StepId;
@property (nonatomic,strong) NSString *UserId;
@property (nonatomic,strong) NSString *LiftNum;
//@property (nonatomic,strong) NSString *DeptId;
//@property (nonatomic,strong) NSString *LiftId;
//@property (nonatomic,strong) NSString *CType;
@end
