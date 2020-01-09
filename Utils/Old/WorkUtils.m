//
//  WorkUtils.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/19.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "WorkUtils.h"

@implementation WorkUtils

+ (void)saveImages:(NSString *)taskId partId:(NSString *)partId data:(NSMutableArray *)array {
    NSString *partTaskId = [NSString stringWithFormat:@"imgs-%@", taskId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:partTaskId]];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
    dic[partId] = [array yy_modelToJSONObject];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:partTaskId];
}

+ (NSMutableArray *)getImagesArray:(NSString *)taskId partId:(NSString *)partId {
    NSString *partTaskId = [NSString stringWithFormat:@"imgs-%@", taskId];
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

+ (NSMutableArray *)getAllImagesArray:(NSString *)taskId {
    NSString *partTaskId = [NSString stringWithFormat:@"imgs-%@", taskId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:partTaskId]];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSArray *array in dic.allValues) {
        [dataArray addObjectsFromArray:array];
    }
    return dataArray;
}

+ (void)updateImagesUrl:(NSString *)taskId partId:(NSString *)partId oldUrl:(NSString *)oldUrl url:(NSString *)url {
    NSString *partTaskId = [NSString stringWithFormat:@"imgs-%@", taskId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:partTaskId]];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:dic[partId]];
    
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSDictionary *dic in tempArray) {
        if ([dic[@"ImageUrl"] isEqualToString:oldUrl]) {
            NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            mdic[@"ImageUrl"] = url;
            mdic[@"isUpload"] = @"1";
            [newArray addObject:mdic];
        } else {
            [newArray addObject:dic];
        }
    }
    NSLog(@"旧%@", tempArray);
    NSLog(@"新%@", newArray);
    [self saveImages:taskId partId:partId data:newArray];
}


+ (void)removeImagesData:(NSString *)taskId partId:(NSString *)partId {
    [self saveImages:taskId partId:partId data:[NSMutableArray array]];
}

+ (void)clearAllImagesData:(NSString *)taskId {
    NSString *partTaskId = [NSString stringWithFormat:@"imgs-%@", taskId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:partTaskId];
}








+ (void)saveRemarks:(NSString *)taskId partId:(NSString *)partId data:(NSMutableArray *)array {
    NSString *partTaskId = [NSString stringWithFormat:@"remarks-%@", taskId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:partTaskId]];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
    dic[partId] = [array yy_modelToJSONObject];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:partTaskId];
}

+ (NSMutableArray *)getRemarksArray:(NSString *)taskId partId:(NSString *)partId {
    NSString *partTaskId = [NSString stringWithFormat:@"remarks-%@", taskId];
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

+ (NSMutableArray *)getAllRemarksArray:(NSString *)taskId {
    NSString *partTaskId = [NSString stringWithFormat:@"remarks-%@", taskId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:partTaskId]];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSArray *array in dic.allValues) {
        [dataArray addObjectsFromArray:array];
    }
    return dataArray;
}

+ (void)updateRemarksUrl:(NSString *)taskId partId:(NSString *)partId oldUrl:(NSString *)oldUrl url:(NSString *)url {
    NSString *partTaskId = [NSString stringWithFormat:@"remarks-%@", taskId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:partTaskId]];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:dic[partId]];
    
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSDictionary *dic in tempArray) {
        if ([dic[@"DataValue"] isEqualToString:oldUrl]) {
            NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            mdic[@"DataValue"] = url;
            mdic[@"isUpload"] = @"1";
            [newArray addObject:mdic];
        } else {
            [newArray addObject:dic];
        }
    }
    NSLog(@"旧%@", tempArray);
    NSLog(@"新%@", newArray);
    [self saveRemarks:taskId partId:partId data:newArray];
}

+ (void)removeRemarksData:(NSString *)taskId partId:(NSString *)partId {
    [self saveRemarks:taskId partId:partId data:[NSMutableArray array]];
}

+ (void)clearAllRemarksData:(NSString *)taskId {
    NSString *partTaskId = [NSString stringWithFormat:@"remarks-%@", taskId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:partTaskId];
}

@end
