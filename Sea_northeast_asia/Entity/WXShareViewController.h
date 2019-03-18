//
//  WXShareViewController.h
//  AlumniChat
//
//  Created by SongQues on 16/6/6.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "UIViewControllerEx.h"
@protocol WXShareDelegate <NSObject>
-(void)btn_Cancel;
@end
@interface WXShareViewController : UIViewControllerEx
{
    UIButton *btn_Circle;
    UIButton *btn_friends;
    UIButton *btn_Cancel;
}
@property (nonatomic,weak)id<WXShareDelegate> wxshareDelegate;
@property (nonatomic,strong)NSString *shareurl;
@property (nonatomic)NSString *type;
@property (nonatomic,strong) NSMutableDictionary *dic_school_info;
@property (nonatomic,strong)NSString *wxtitle;
@property (nonatomic,strong)NSString *wxMemo;
@property (nonatomic,strong)NSString *wxImage;
@end
