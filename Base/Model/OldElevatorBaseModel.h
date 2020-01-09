//
//  OldElevatorBaseModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/13.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OldElevatorBaseModel : NSObject
@property (nonatomic, assign) NSInteger Code;
@property (nonatomic, assign) NSInteger Count;


@property (nonatomic, assign) NSInteger Success;
@property (nonatomic, copy) NSString *Message;

@property (nonatomic, strong) id Data;

@end
