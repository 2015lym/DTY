//
//  EWMDetailViewController.h
//  Sea_northeast_asia
//
//  Created by 王永超 on 2017/3/23.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "ClassIfication.h"
#import "CurriculumEntity.h"
#import "DTWBWebViewController.h"
@interface EWMDetailViewController : UIViewControllerEx<UITableViewExViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableViewExViewController *CourseTableview;
}

@property (nonatomic,strong) AppDelegate *app;

@property (nonatomic,strong) NSString *liftNum;

@property (nonatomic,strong) NSString *liftID;

@end
