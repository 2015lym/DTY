//
//  handleRecordeCell.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/12/15.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UITableViewCellEx.h"

@interface handleRecordeCell : UITableViewCellEx
@property (weak, nonatomic) IBOutlet UILabel *labID;

//@property (weak, nonatomic) IBOutlet UILabel *labStatus;
@property (weak, nonatomic) IBOutlet UILabel *labAddr;
@property (weak, nonatomic) IBOutlet UILabel *labTotalTime;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
//@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labLine;

@property (weak, nonatomic) IBOutlet UILabel *labBack;
@property (weak, nonatomic) IBOutlet UIView *viewRight;
@end
