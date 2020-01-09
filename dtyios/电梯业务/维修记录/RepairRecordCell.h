//
//  RepairRecordCell.h
//  Sea_northeast_asia
//
//  Created by wyc on 2018/1/8.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCellEx.h"
@interface RepairRecordCell : UITableViewCellEx
@property (strong, nonatomic) IBOutlet UILabel *labNum;
@property (strong, nonatomic) IBOutlet UILabel *labAddress;
@property (strong, nonatomic) IBOutlet UILabel *labTime;

@property (strong, nonatomic) IBOutlet UILabel *lab1;
@property (strong, nonatomic) IBOutlet UILabel *lab2;
@property (strong, nonatomic) IBOutlet UILabel *lab3;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UILabel *labbottom;


@end
