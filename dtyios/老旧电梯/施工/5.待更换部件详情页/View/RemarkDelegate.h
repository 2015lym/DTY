//
//  RemarkDelegate.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/20.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RemarkDelegate <NSObject>

- (void)changeData:(NSMutableArray *)array type:(NSString *)type text:(NSString *)text;

@end
