//
//  AddPeopleViewController.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/5/24.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UITableViewExViewController.h"
@interface AddPeopleViewController : UIViewController<UITableViewExViewDelegate,CourseHearViewDelegate,NIMNetCallManagerDelegate,NIMNetCallManager>
{
    NSMutableArray *_allTypes;
    UITableViewExViewController *CourseTableview;
}
@property (nonatomic,strong) AppDelegate *app;


@end
