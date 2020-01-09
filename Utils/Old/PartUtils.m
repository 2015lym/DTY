//
//  PartUtils.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/18.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "PartUtils.h"

@implementation PartUtils

+ (void)saveParts:(NSString *)taskId partId:(NSString *)partId data:(NSMutableArray *)array {
    NSString *partTaskId = [NSString stringWithFormat:@"parts-%@", taskId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:partTaskId]];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
    dic[partId] = [array yy_modelToJSONObject];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:partTaskId];
}

+ (NSMutableArray *)getPartsArray:(NSString *)taskId partId:(NSString *)partId {
    NSString *partTaskId = [NSString stringWithFormat:@"parts-%@", taskId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:partTaskId]];
    if (!dic) {
        return [NSMutableArray array];
    } else {
        if (dic[partId]) {
            return dic[partId];
        } else {
            return [NSMutableArray array];
        }
    }
}

+ (NSMutableArray *)getAllPartsArray:(NSString *)taskId {
    NSString *partTaskId = [NSString stringWithFormat:@"parts-%@", taskId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:partTaskId]];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSArray *array in dic.allValues) {
        [dataArray addObjectsFromArray:array];
    }
    return dataArray;
}

+ (void)clearAllPartsData:(NSString *)taskId {
    NSString *partTaskId = [NSString stringWithFormat:@"parts-%@", taskId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:partTaskId];
}

@end
 
