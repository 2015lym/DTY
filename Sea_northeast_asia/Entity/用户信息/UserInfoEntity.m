//
//  LoginEntity.m
//  HIChat
//
//  Created by Song Ques on 14-4-14.
//  Copyright (c) 2014年 Song Ques. All rights reserved.
//

#import "userInfoEntity.h"

@implementation UserInfoEntity


@synthesize username;
@synthesize nikename;
@synthesize pwd;
@synthesize uhead;

@synthesize UserID;
@synthesize DeptRoleCode;
@synthesize RoleId;
- (void)setUserInfo:(NSString *)_username forNikename:(NSString *)_nikename
forpwd:(NSString *)_pwd forhead:(NSString *)_uhead{
    username=_username;
    nikename=_nikename;
    pwd=_pwd;
    uhead=_uhead;
}

- (void)setUserInfo:(NSString *)_username
             forpwd:(NSString *)_pwd
          forUserID:(NSString *)_UserID
    forDeptRoleCode:(NSString *)_DeptRoleCode
          forRoleId:(NSString *)_RoleId
       forNikename:(NSString *)_nikename
{
    username=_username;
    pwd=_pwd;
    UserID=_UserID;
    DeptRoleCode=_DeptRoleCode;
    RoleId = _RoleId;
    nikename=_nikename;
}

@end
