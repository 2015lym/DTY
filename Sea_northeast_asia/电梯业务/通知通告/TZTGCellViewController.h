//
//  TZTGCellViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/15.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCellEx.h"
@interface TZTGCellViewController : UITableViewCellEx
@property (strong, nonatomic) IBOutlet UILabel *labNum;
@property (strong, nonatomic) IBOutlet UILabel *labAddress;
@property (strong, nonatomic) IBOutlet UILabel *labTime;

@property (strong, nonatomic) IBOutlet UIImageView *imgtime;
@end
