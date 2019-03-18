//
//  SBAZCell4.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/4/7.
//  Copyright © 2017年 SongQues. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UITableViewCellEx.h"
@interface SBAZCell4 : UITableViewCellEx
@property (weak, nonatomic) IBOutlet UILabel *labID;

@property (weak, nonatomic) IBOutlet UILabel *labStatus;
@property (weak, nonatomic) IBOutlet UILabel *labAddr;
@property (weak, nonatomic) IBOutlet UILabel *labTotalTime;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labLine;

@property (weak, nonatomic) IBOutlet UILabel *labBack;
@property (weak, nonatomic) IBOutlet UIView *viewRight;

@end
