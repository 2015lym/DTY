//
//  OldUserModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/5.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OldUserModel : NSObject
@property (nonatomic, copy) NSString *Account;
@property (nonatomic, copy) NSString *RealName;
@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, copy) NSString *Mobile;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *RoleId;
@property (nonatomic, copy) NSString *PostId;
@property (nonatomic, copy) NSString *UserSign;


@end
