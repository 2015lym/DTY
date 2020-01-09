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
#import "videoHistroyViewController.h"
#import "XXNet.h"
@interface AddPeopleViewController : UIViewController<UITableViewExViewDelegate,CourseHearViewDelegate,NIMNetCallManagerDelegate,NIMNetCallManager,SchoolCourseDelegate>
{
    UITextField *txtSearch;
    
    NSMutableArray *_allTypes;
    UITableViewExViewController *CourseTableview;
    
    UILabel *line;
    int tabCurrent;
    
    videoHistroyViewController  *myhandleRecorde ;
    
    NSMutableArray *array_newJS;
}
@property (nonatomic,strong) AppDelegate *app;
@property (nonatomic,strong) NSString *roomid;

@end
