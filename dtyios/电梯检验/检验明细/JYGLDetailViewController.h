//
//  JYGLDetailViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/24.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFAppDotNetAPIClient.h"
#import "AppDelegate.h"
#import "CommonUseClass.h"
#import "SZConfigure.h"
#import "SZQuestionCheckBox.h"
#import "warningElevatorModel.h"
#import "XXNet.h"
#import "CurriculumEntity.h"
#import "showImage.h"
#import "VideoViewController.h"
@interface JYGLDetailViewController : UIViewController<UITableViewExViewDelegate>
{
    NSString *UploadDate;
    NSString *InstallationAddress;
    NSString *liftID;
    
    UIView *bgView;
    UIButton *leftBtn;
    UIButton *centertBtn;
    UIButton *rightBtn;
    UILabel *btnLine;
    
    UITableViewExViewController *CourseTableview;
    int typeID;
    NSArray *arrData;
}
@property (nonatomic,strong) AppDelegate *app;
@property (weak, nonatomic) NSString *liftNum;
@property (weak, nonatomic) warningElevatorModel  *model;

@property (nonatomic, strong) SZQuestionCheckBox *questionBox;
@property (nonatomic, strong) SZQuestionItem *item;
@end
