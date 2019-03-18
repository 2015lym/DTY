//
//  WBDetailViewController.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/4/7.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "ClassIfication.h"
#import "CurriculumEntity.h"
#import "UITableViewExViewController.h"
#import "DTWBDetailViewController.h"
@interface WBDetailViewController : UIViewControllerEx<UITableViewExViewDelegate,ClassIficationDelegate,CourseHearViewDelegate>
{
    ClassIfication *view_ification_02;
    UITableViewExViewController *CourseTableview;
}

@property (nonatomic,strong) AppDelegate *app;

@property (nonatomic,strong) NSString *liftNum;


@end
