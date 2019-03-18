//
//  QRCodeViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 17/2/13.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZConfigure.h"
#import "SZQuestionCheckBox.h"
#import "WBDCViewController.h"
#import "AppDelegate.h"
@interface QRCodeViewController : UIViewController

@property (nonatomic, strong) SZQuestionCheckBox *questionBox;
@property (nonatomic, strong) SZQuestionItem *item;
@property (nonatomic,strong) AppDelegate *app;
@end
