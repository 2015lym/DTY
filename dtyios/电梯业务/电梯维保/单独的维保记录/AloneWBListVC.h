//
//  AloneWBListVC.h
//  Sea_northeast_asia
//
//  Created by wyc on 2018/2/27.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ClassIfication.h"
#import "CurriculumEntity.h"
#import "UITableViewExViewController.h"
@interface AloneWBListVC : UIViewControllerEx<UITableViewExViewDelegate,ClassIficationDelegate,CourseHearViewDelegate>
{
    ClassIfication *view_ification_02;
    UITableViewExViewController *CourseTableview;
}

@property (nonatomic,strong) AppDelegate *app;
@end
