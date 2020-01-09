//
//  DTWBDetailCell.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/5/10.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "UITableViewCellEx.h"
#import "appDelegate.h"
@interface DTWBDetailCell : UITableViewCellEx
@property (nonatomic,strong) AppDelegate *app;
@property (weak, nonatomic) IBOutlet UILabel *lab_Title1;
@property (weak, nonatomic) IBOutlet UILabel *lab_Title2;
@property (weak, nonatomic) IBOutlet UILabel *lab_Title3;
@property (weak, nonatomic) IBOutlet UILabel *lab_Title4;
@property (weak, nonatomic) IBOutlet UILabel *lab_Title5;
//@property (weak, nonatomic) IBOutlet UILabel *lab_Title6;

@property (weak, nonatomic) IBOutlet UITextView *lab_Detail1;
@property (weak, nonatomic) IBOutlet UILabel *lab_Detail2;
@property (weak, nonatomic) IBOutlet UILabel *lab_Detail3;
@property (weak, nonatomic) IBOutlet UILabel *lab_Detail4;
@property (weak, nonatomic) IBOutlet UILabel *lab_Detail5;

@property (weak, nonatomic) IBOutlet UIImageView *view_Image;

@property (weak, nonatomic) IBOutlet UILabel *lab_time;

@property (weak, nonatomic) IBOutlet UILabel *lab_back1;
@property (weak, nonatomic) IBOutlet UITextField *lab_back2;
@property (weak, nonatomic) IBOutlet UILabel *lab_line;

@property (weak, nonatomic) IBOutlet UIImageView *view_Image1;
@property (weak, nonatomic) IBOutlet UIImageView *view_Image2;
@property (weak, nonatomic) IBOutlet UIImageView *view_Image3;
@end
