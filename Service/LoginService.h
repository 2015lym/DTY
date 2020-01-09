//
//  LoginService.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/3/21.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginService : NSObject

+ (void)checkLoginState:(NSURLSessionDataTask *)task;

@end

