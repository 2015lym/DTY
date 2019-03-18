//
//  LeftViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/6/29.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "UIViewControllerEx.h"
#import "LeftWebViewController.h"
@protocol LeftViewDelegate <NSObject>
@required
//侧滑手势关闭视图
-(void)leftCloseView;
-(void)leftPshuWebview:(NSString *)url;
@end
@interface LeftViewController : UIViewControllerEx
{
    IBOutlet UIView *view_Menu;
    
}
@property(nonatomic,weak)id<LeftViewDelegate> delegate;
-(IBAction)root_View_ClickEvent:(id)sender;
@end
