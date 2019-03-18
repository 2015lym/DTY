//
//  QRCodeViewController_WZH.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/7/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZConfigure.h"
#import "SZQuestionCheckBox.h"
#import "WBDCViewController_WZH.h"
#import "AppDelegate.h"
@interface QRCodeViewController_WZH : UIViewController
{
    int isOK;
}
@property (nonatomic, strong) SZQuestionCheckBox *questionBox;
@property (nonatomic, strong) SZQuestionItem *item;

@property (nonatomic,strong) AppDelegate *app;
@end
