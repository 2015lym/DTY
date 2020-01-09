//
//  ExamineUtils.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/27.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "ExamineUtils.h"

@implementation ExamineUtils

+ (void)saveExamines:(NSString *)taskId categoryId:(NSString *)categoryId data:(NSMutableArray *)array {
    NSString *partTaskId = [NSString stringWithFormat:@"examines-%@", taskId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:partTaskId]];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
    dic[categoryId] = [array yy_modelToJSONObject];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:partTaskId];
}

+ (NSMutableArray *)getExaminesArray:(NSString *)taskId categoryId:(NSString *)categoryId {
    NSString *partTaskId = [NSString stringWithFormat:@"examines-%@", taskId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:partTaskId]];
    if (!dic) {
        return [NSMutableArray array];
    } else {
        if (dic[categoryId]) {
            return dic[categoryId];
        } else {
            return [NSMutableArray array];
        }
    }
}

+ (NSMutableArray *)getAllExaminesArray:(NSString *)taskId {
    NSString *partTaskId = [NSString stringWithFormat:@"examines-%@", taskId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:partTaskId]];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSArray *array in dic.allValues) {
        [dataArray addObjectsFromArray:array];
    }
    return dataArray;
}

+ (void)clearAllExaminesData:(NSString *)taskId {
    NSString *partTaskId = [NSString stringWithFormat:@"examines-%@", taskId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:partTaskId];
}

@end
