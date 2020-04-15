//
//  SBTSModel.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/9.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBTSModel : NSObject
-(NSData *)getByteForInt:(NSString *)string;
-(NSData *)getE1:(NSData *)data;
-(NSData *)getE2;
-(NSData *)getE2_1:(NSData *)data forzcCode:(NSString  *)zcCode  forType :(Byte)type;
-(NSData *)getE3:(NSData *)data forType:(Byte)type;

-(NSData *)getE4:(NSData *)data;
-(NSData *)getE5:(NSData *)data andAddress:(NSString *)address;
-(NSData *)getSimE5:(NSData *)data;
@end
