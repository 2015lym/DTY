//
//  UINavViewControllerEx.h
//  YONChat
//
//  Created by SongQues on 14/11/6.
//
//

#import <UIKit/UIKit.h>
#import "UIViewControllerEx.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "Util.h"
@interface UINavViewControllerEx : UIViewControllerEx<UINavigationControllerDelegate>

{
    UIButton *left_BarButton_Item;
    UILabel *lab_Item;
    UIBarButtonItem *addItem;
    UIButton *right_BarButoon_Item;
    UIBarButtonItem *rightItem;
    LeftViewController * lableVC;
    RightViewController * rightVC;
}
-(IBAction)pop_messageCenterView:(id)sender;

@end
