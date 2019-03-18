//
//  DTWBViewController.h
//  Sea_northeast_asia
//
//  Created by 王永超 on 2017/3/23.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "ClassIfication.h"
#import "CurriculumEntity.h"
#import "UITableViewExViewController.h"
#import "mySelect.h"
@interface DTWBViewController : UIViewControllerEx<UITableViewExViewDelegate,ClassIficationDelegate,CourseHearViewDelegate>
{
    ClassIfication *view_ification_02;
    UITableViewExViewController *CourseTableview;
    mySelect *mySelectView;
}

@property (nonatomic,strong) AppDelegate *app;

@end
