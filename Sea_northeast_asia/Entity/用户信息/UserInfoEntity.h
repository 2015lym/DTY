//
//  LoginEntity.h
//  HIChat
//
//  Created by Song Ques on 14-4-14.
//  Copyright (c) 2014年 Song Ques. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoEntity : NSObject


@property (nonatomic, retain) NSString *RoleId;
@property (nonatomic ,strong) NSString *username;
@property (nonatomic ,strong) NSString *nikename;
@property (nonatomic ,strong) NSString *pwd;
@property (nonatomic ,strong) NSString *uhead;

@property (nonatomic ,strong) NSString *UserID;
@property (nonatomic ,strong) NSString *DeptRoleCode;



- (void)setUserInfo:(NSString *)_username
             forpwd:(NSString *)_pwd
          forUserID:(NSString *)_UserID
    forDeptRoleCode:(NSString *)_DeptRoleCode
          forRoleId:(NSString *)_RoleId
        forNikename:(NSString *)_nikename;

- (void)setUserInfo:(NSString *)_username
        forNikename:(NSString *)_nikename
             forpwd:(NSString *)_pwd
            forhead:(NSString *)_uhead;

@end
