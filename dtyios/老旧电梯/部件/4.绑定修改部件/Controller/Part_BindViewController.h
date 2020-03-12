//
//  Part_BindViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/13.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"

@interface Part_BindViewController : YMBaseViewController

@property (nonatomic, assign) BOOL isBind;
@property (nonatomic, strong) NSArray *partsArray;

@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *elevatorPartRecordId;



@end
