//
//  getStateAction.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/28.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "FMDB.h"
@interface getStateAction : NSObject
{
    FMDatabase *_mDB;
    sqlite3 *db;
}
- (void)GetLastStatusActionList;
+(NSString *)getDatabaseFileName;
@end
