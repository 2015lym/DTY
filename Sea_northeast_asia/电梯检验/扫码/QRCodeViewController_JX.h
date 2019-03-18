//
//  QRCodeViewController_JX.h
//  Sea_northeast_asia
//
//  Created by SinodomMac on 2017/6/13.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZQuestionCheckBox.h"
#import "UITableViewExViewController.h"
#import "UITableViewExForDeleteViewController.h"

#import "myBMKPointAnnotation.h"
#import "EventCurriculumEntity.h"
#import "XXNet.h"
#import "JYTypeViewController.h"
#import "QRCode_Write.h"
#import "writeNameViewController.h"
@interface QRCodeViewController_JX : UIViewController
{
    UIView *viewLast;
    
    
    
    
    EventCurriculumEntity *entity;

    NSString *LiftNum;   
    NSArray * arrData;
}
@property (nonatomic,strong) NSString *Type_ID;
@property (nonatomic, strong) SZQuestionItem *item;
@property (nonatomic, strong) SZQuestionCheckBox *questionBox;
@property (nonatomic,strong) AppDelegate *app;
@property ( nonatomic)  NSString * companyType;
//@property (nonatomic, strong) SZQuestionItem *item;
@end
