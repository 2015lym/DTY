//
//  UserService.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/3/28.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "UserService.h"

@implementation UserService

+ (void)setUserType:(NSString *)type {
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:@"userType"];
}

+ (NSString *)getUserType {
    NSString *userType = [[NSUserDefaults standardUserDefaults] valueForKey:@"userType"];
    if ([StringFunction isBlankString:userType]) {
        return @"normal";
    } else {
        return userType;
    }
}
#pragma mark - ---------- 老旧信息 ----------
+ (void)setOldUserInfo:(OldUserModel *)model {
    NSString *userInfoString = [model yy_modelToJSONString];
    [[NSUserDefaults standardUserDefaults] setObject:userInfoString forKey:@"userInfo"];
}

+ (OldUserModel *)getOldUserInfo {
    NSString *userInfoString = [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"];
    if ([StringFunction isBlankString:userInfoString]) {
        return [[OldUserModel alloc] init];
    } else {
        NSDictionary *dic = [StringFunction stringToDic:userInfoString];
        OldUserModel *model = [OldUserModel yy_modelWithJSON:dic];
        return model;
    }
}

#pragma mark - ---------- 用户信息 ----------
+ (void)setUserInfo:(UserModel *)model {
    NSString *userInfoString = [model yy_modelToJSONString];
    [[NSUserDefaults standardUserDefaults] setObject:userInfoString forKey:@"userInfo"];
}

+ (UserModel *)getUserInfo {
    NSString *userInfoString = [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"];
    if ([StringFunction isBlankString:userInfoString]) {
        return [[UserModel alloc] init];
    } else {
        NSDictionary *dic = [StringFunction stringToDic:userInfoString];
        UserModel *model = [UserModel yy_modelWithJSON:dic];
        return model;
    }
}

+ (void)clearUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userType"];
}


+ (void)setUserToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"token"];
}

+ (NSString *)getUserToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    if ([StringFunction isBlankString:token]) {
        return @"";
    } else {
        return token;
    }
}

+ (void)setJing:(NSString *)jing wei:(NSString *)wei {
    [[NSUserDefaults standardUserDefaults] setValue:jing forKey:@"jing"];
    [[NSUserDefaults standardUserDefaults] setValue:wei forKey:@"wei"];
    NSLog(@"设置了经%@，纬%@", jing, wei);
}

+ (NSString *)getJing {
    NSString *jing = [[NSUserDefaults standardUserDefaults] valueForKey:@"jing"];
    if ([StringFunction isBlankString:jing]) {
        return @"";
    } else {
        return jing;
    }
}

+ (NSString *)getWei {
    NSString *wei = [[NSUserDefaults standardUserDefaults] valueForKey:@"wei"];
    if ([StringFunction isBlankString:wei]) {
        return @"";
    } else {
        return wei;
    }
}

+ (void)setUserAddress:(NSString *)address {
    [[NSUserDefaults standardUserDefaults] setValue:address forKey:@"address"];
}

+ (NSString *)getUserAddress {
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"address"];
    if ([StringFunction isBlankString:token]) {
        return @"无法获取位置";
    } else {
        return token;
    }
}
@end
