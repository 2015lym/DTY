//
//  JYGLListViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/23.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "ClassIfication.h"
#import "CurriculumEntity.h"
#import "mySelect.h"
#import "XXNet.h"
#import "JYGLDetailViewController.h"
#import "QRCodeViewController_JX.h"
@interface JYGLListViewController :UIViewControllerEx <UITableViewExViewDelegate,ClassIficationDelegate>
{
    ClassIfication *view_ification_02;
    UITableViewExViewController *CourseTableview;
    mySelect *mySelectView;
}

@property (nonatomic,strong) AppDelegate *app;

@end
