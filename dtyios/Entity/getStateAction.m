//
//  getStateAction.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/28.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "getStateAction.h"
#import "AFAppDotNetAPIClient.h"
@implementation getStateAction
//给表添加数据
- (void)GetLastStatusActionList
{
    NSString *currUrl=[NSString stringWithFormat:@"Task/GetLastStatusActionList"];
    
    [[AFAppDotNetAPIClient sharedClient]
     GET:currUrl
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {  }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {        
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if(dic_result[@"Success"])
         {
             NSArray *array = [[dic_result objectForKey:@"Data"] objectFromJSONString];
             if (array.count>0) {
                 [self writeDatabase:array];
             }
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
     }];
}

-(void)writeDatabase :(NSArray *) array
{
    // 取得沙盒目录
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 要检查的文件目录
    NSString *fileName = [localPath  stringByAppendingPathComponent:@"SinodomSQLite.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName]) {
         BOOL isSuccess = [fileManager removeItemAtPath:fileName error:nil];
        if(isSuccess)
        {
             NSLog(@"delete ok");
        }
        else
            return;
    }
    else {
        NSLog(@"文件abc.doc不存在");
    }

    
    _mDB=[FMDatabase databaseWithPath: fileName];
    [_mDB open];
    
    //确保数据库被加载
    if (_mDB != nil) {
        if ([_mDB open]) {
            BOOL result = [_mDB executeUpdate:@"CREATE TABLE IF NOT EXISTS TL_StatusAction(id integer primary key,StatusId integer,StatusName text,UserType integer,ActionName text,Argument integer);"];
            if (result)
            {
                NSLog(@"创建表成功");
            }
            else
                return;
            
            //1.delete
            NSString *sql=@"delete from TL_StatusAction;";
            BOOL ret=[_mDB executeQuery:sql];
            if (ret)
            {
                NSLog(@"delete成功");
            }
            else
                return;
      
            //2.insert
            for (int i = 0; i < array.count; i ++) {

                NSString *ID=[NSString stringWithFormat:@"%@",[array[i] valueForKey:@"ID"]];
                NSString *StatusId=[NSString stringWithFormat:@"%@",[array[i] valueForKey:@"StatusId"]];
                NSString *StatusName=[NSString stringWithFormat:@"%@",[array[i] valueForKey:@"StatusName"]];
                NSString *UserType=[NSString stringWithFormat:@"%@",[array[i] valueForKey:@"UserType"]];
                NSString *ActionName=[NSString stringWithFormat:@"%@",[array[i] valueForKey:@"ActionName"]];
                NSString *Argument=[NSString stringWithFormat:@"%@",[array[i] valueForKey:@"Argument"]];

                BOOL isOK = [_mDB executeUpdateWithFormat:@"insert into TL_StatusAction (id,StatusId,StatusName,UserType,ActionName,Argument) values(%@,%@,%@,%@,%@,%@);",ID,StatusId,StatusName,UserType,ActionName,Argument];
                if (isOK == YES) {
                    NSLog(@"添加数据成功");
                }
            }
            
            //2.select
            NSString* sqlselect=@"select * from TL_StatusAction";
            FMResultSet*set=[_mDB executeQuery:sqlselect];
            int count=0;
            while([set next])
            {
                count=[set intForColumn:0];
                NSLog(@" count is %d",count);
            }
            
        }
    }
}

+(NSString *)getDatabaseFileName{
    NSString *fileName=[[NSBundle mainBundle] pathForResource:@"SinodomSQLite" ofType:@"sqlite"];
    // 取得沙盒目录
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 要检查的文件目录
    NSString *fileName_sh = [localPath  stringByAppendingPathComponent:@"SinodomSQLite.sqlite"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:fileName_sh]) {
            fileName=fileName_sh;
        }
        else {
            NSLog(@"文件abc.doc不存在");
        }
    
    return fileName;
}
@end
