//
//  ExamineUtils.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/27.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamineUtils : NSObject

+ (void)saveExamines:(NSString *)taskId categoryId:(NSString *)categoryId data:(NSMutableArray *)array;

+ (NSMutableArray *)getExaminesArray:(NSString *)taskId categoryId:(NSString *)categoryId;

+ (NSMutableArray *)getAllExaminesArray:(NSString *)taskId;

+ (void)clearAllExaminesData:(NSString *)taskId;

@end
