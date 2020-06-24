//
//  UserService.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/3/28.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OldUserModel.h"
#import "UserModel.h"

@interface UserService : NSObject

+ (void)setUserType:(NSString *)type;
+ (NSString *)getUserType;


+ (void)setOldUserInfo:(OldUserModel *)model;
+ (OldUserModel *)getOldUserInfo;

+ (void)setUserInfo:(UserModel *)model;
+ (UserModel *)getUserInfo;

+ (void)clearUserInfo;





+ (void)setUserToken:(NSString *)token;
+ (NSString *)getUserToken;

+ (void)setJing:(NSString *)jing wei:(NSString *)wei;

+ (NSString *)getJing;
+ (NSString *)getWei;


+ (void)setUserAddress:(NSString *)address;
+ (NSString *)getUserAddress;

@end

