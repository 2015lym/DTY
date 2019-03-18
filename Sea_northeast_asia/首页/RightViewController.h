//
//  RightViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/6/29.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "UIViewControllerEx.h"
//#import "appDelegate.h"
#import "AFAppDotNetAPIClient.h"
#import "EGOImageView.h"
#import "EGOCache.h"
@protocol RightViewDelegate <NSObject>
@required
//侧滑手势关闭视图
-(void)rightCloseView;
-(void)rightLoginEvent;
-(void)rightAboutEvent;
-(void)rightMessageCenter;
-(void)setHidden;//重置消息
@end
@interface RightViewController : UIViewControllerEx
{
    IBOutlet UIView *view_Menu;
    IBOutlet UIView *view_Message;
    UIImageView *imageRed;
    __weak IBOutlet EGOImageView *personHead;
    __weak IBOutlet UILabel *personNikename;
    NSString *str_CachePath_baiduPushSetSelect;
    
    __weak IBOutlet UILabel *lab_Cache;
}
@property(nonatomic,weak)id<RightViewDelegate> delegate;
-(IBAction)btn_Login_Event:(id)sender;
-(void)showPersonInfo;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *baiduPushChang;
//- (IBAction)baiduPushChangBtn:(id)sender;
-(void)setImageRed:(BOOL)hidden;

@property (weak, nonatomic) IBOutlet UISwitch *baiduPushChang1;
- (IBAction)baiduPushChangeBtn1:(id)sender;
- (IBAction)btnclearCache:(id)sender;



//@property (nonatomic,strong) AppDelegate *app;
@end
