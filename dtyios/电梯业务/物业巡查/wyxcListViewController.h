//
//  wyxcListViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/17.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "ClassIfication.h"
#import "CurriculumEntity.h"
#import "UITableViewExViewController.h"
#import "mySelect.h"
#import "XXNet.h"
#import "wyxcDetailViewController.h"
#import "QRCodeViewController_WYXC.h"
@interface wyxcListViewController : UIViewController<UITableViewExViewDelegate,ClassIficationDelegate,CourseHearViewDelegate>
{
    ClassIfication *view_ification_02;
    UITableViewExViewController *CourseTableview;
    mySelect *mySelectView;
}

@property (nonatomic,strong) AppDelegate *app;



@end
