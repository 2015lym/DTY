//
//  baiduMap.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/8/17.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol baiduMapDelegate <NSObject>
-(void)baiduMapPush:(NSString *)longitude for: (NSString *)latitude;
@end
