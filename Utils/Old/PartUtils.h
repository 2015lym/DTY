//
//  PartUtils.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/18.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartUtils : NSObject

+ (void)saveParts:(NSString *)taskId partId:(NSString *)partId data:(NSMutableArray *)array;

+ (NSMutableArray *)getPartsArray:(NSString *)taskId partId:(NSString *)partId;

+ (NSMutableArray *)getAllPartsArray:(NSString *)taskId;

+ (void)clearAllPartsData:(NSString *)taskId;

@end
