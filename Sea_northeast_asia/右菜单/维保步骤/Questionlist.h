//
//  Questionlist.h
//  Sea_northeast_asia
//
//  Created by likuo on 2017/4/13.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Questionlist : NSObject
@property (weak, nonatomic) NSString *Guid;
@property (weak, nonatomic) NSString *Num;
@property (weak, nonatomic) NSString *Qtitle;
@property (weak, nonatomic) NSString *Show;

@property (weak, nonatomic) NSString *Phone;
@property (weak, nonatomic) NSString *Qfrom;
@property (weak, nonatomic) NSString *ParkID;
@property (weak, nonatomic) NSString *Remark;

@property(nonatomic,strong) NSArray *Questionlist;
@end
