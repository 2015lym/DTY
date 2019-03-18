//
//  DTWBDetailClass.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/5/10.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "UITableItem.h"
#import "DTWBStepClass.h"
#import "DTWBUserClass.h"

@interface DTWBDetailClass : UITableItem

@property(nonatomic,strong)NSString * CheckDate;
@property(nonatomic,strong)NSString * IsPassed;
@property(nonatomic,strong)DTWBStepClass * Step;
@property(nonatomic,strong)NSString * PhotoUrl;
@property(nonatomic,strong)NSString * Remark;
@property(nonatomic,strong)DTWBUserClass * User;

@end
