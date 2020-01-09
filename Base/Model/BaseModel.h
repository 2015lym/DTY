//
//  BaseModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/3/26.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
@property (nonatomic, assign) NSInteger __abp;
@property (nonatomic, assign) NSInteger success;
@property (nonatomic, assign) NSInteger Success;
@property (nonatomic, assign) NSInteger unAuthorizedRequest;

@property (nonatomic, copy) NSString *error;
@property (nonatomic, copy) NSString *targetUrl;

@property (nonatomic, strong) id data;
@property (nonatomic, strong) id result;

@end
