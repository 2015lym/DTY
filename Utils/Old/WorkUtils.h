//
//  WorkUtils.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/19.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkUtils : NSObject

+ (void)saveImages:(NSString *)taskId partId:(NSString *)partId data:(NSMutableArray *)array;

+ (NSMutableArray *)getImagesArray:(NSString *)taskId partId:(NSString *)partId;

+ (NSMutableArray *)getAllImagesArray:(NSString *)taskId;

+ (void)updateImagesUrl:(NSString *)taskId partId:(NSString *)partId oldUrl:(NSString *)oldUrl url:(NSString *)url;

+ (void)removeImagesData:(NSString *)taskId partId:(NSString *)partId;

+ (void)clearAllImagesData:(NSString *)taskId;



+ (void)saveRemarks:(NSString *)taskId partId:(NSString *)partId data:(NSMutableArray *)array;

+ (NSMutableArray *)getRemarksArray:(NSString *)taskId partId:(NSString *)partId;

+ (NSMutableArray *)getAllRemarksArray:(NSString *)taskId;

+ (void)updateRemarksUrl:(NSString *)taskId partId:(NSString *)partId oldUrl:(NSString *)oldUrl url:(NSString *)url;

+ (void)removeRemarksData:(NSString *)taskId partId:(NSString *)partId;

+ (void)clearAllRemarksData:(NSString *)taskId;

@end
