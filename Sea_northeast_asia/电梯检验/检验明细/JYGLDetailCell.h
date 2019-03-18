//
//  JYGLDetailCell.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/24.
//  Copyright © 2018年 SongQues. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UITableViewCellEx.h"
#import "CommonUseClass.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "EGOImageView.h"
#import "showImage.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
@interface JYGLDetailCell : UITableViewCellEx
{UIImageView *item;}

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labConcent;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UITextField *lab_back1;
@property (weak, nonatomic) IBOutlet UITextField *lab_back2;
@property (weak, nonatomic) IBOutlet UIButton *btn_look;
@property (weak, nonatomic) IBOutlet UIView *viewRight;

@end
