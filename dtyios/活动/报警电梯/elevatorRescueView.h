//
//  elevatorRescueView.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/8.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyControl.h"
@interface elevatorRescueView : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UILabel *lable3;
@property (weak, nonatomic) IBOutlet UILabel *lable4;
@property (weak, nonatomic) IBOutlet UILabel *lable5;
@property (weak, nonatomic) IBOutlet UILabel *lable6;
@property (weak, nonatomic) IBOutlet UILabel *lable7;
@property (weak, nonatomic) IBOutlet UILabel *lable8;
@property (weak, nonatomic) IBOutlet UILabel *lable9;
@property (weak, nonatomic) IBOutlet UILabel *lable10;
@property (weak, nonatomic) IBOutlet UILabel *lable11;
@property (weak, nonatomic) IBOutlet UIView *v1;
@property (weak, nonatomic) IBOutlet UIView *v2;
@property (weak, nonatomic) IBOutlet UIView *v3;
@property (weak, nonatomic) IBOutlet UIView *v4;


-(void)changeLableText:(NSString *) lab1 for2:(NSString *) lab2 for4:(NSString *) lab4 for6:(NSString *) lab6 for7:(NSString *) lab7
 for9:(NSString *) lab9 for10:(NSString *) lab10;
@end



