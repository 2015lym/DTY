//
//  RepairRecordVC.h
//  Sea_northeast_asia
//
//  Created by wyc on 2018/1/8.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewExViewController.h"
#import "CurriculumEntity.h"
#import "AppDelegate.h"
#import "mySelect.h"
#import "QRCodeViewController_WXJL.h"
@interface RepairRecordVC : UIViewControllerEx<UITableViewExViewDelegate> {
    UITableViewExViewController *CourseTableview;
    mySelect *mySelectView;
}
@property (nonatomic,strong) AppDelegate *app;

@end
