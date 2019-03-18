//
//  PhysicalUnionVC.h
//  Sea_northeast_asia
//
//  Created by wyc on 2018/1/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UITableViewExViewController.h"
#import "mySelect.h"
@interface PhysicalUnionVC : UIViewControllerEx<UITableViewExViewDelegate> {
    UITableViewExViewController *CourseTableview;
    mySelect *mySelectView;
}
@property (nonatomic,strong) AppDelegate *app;

@end
