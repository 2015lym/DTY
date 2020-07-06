//
//  UserModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/5.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic, retain) NSString *roleId;
@property (nonatomic ,strong) NSString *username;
@property (nonatomic ,strong) NSString *nickname;
@property (nonatomic ,strong) NSString *pwd;
@property (nonatomic ,strong) NSString *uhead;

@property (nonatomic ,strong) NSString *userId;
@property (nonatomic ,strong) NSString *deptRoleCode;

@property (nonatomic, assign) BOOL isSuperVision;

@end
