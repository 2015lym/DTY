//
//  PJGLSaveCell.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/19.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableViewCellEx.h"
@interface PJGLSaveCell : UITableViewCellEx
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (strong, nonatomic) IBOutlet UILabel *labAddress;
@property (strong, nonatomic) IBOutlet UILabel *labNum;

@property (weak, nonatomic) IBOutlet UILabel *labType;
@property (strong, nonatomic) IBOutlet UILabel *labTime;

@property (strong, nonatomic) IBOutlet UIImageView *imgtime;
@end
