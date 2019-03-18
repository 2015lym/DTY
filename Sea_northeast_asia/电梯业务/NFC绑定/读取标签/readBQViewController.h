//
//  readBQViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/11/5.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "XXNet.h"
NS_ASSUME_NONNULL_BEGIN

@interface readBQViewController : UIViewController
{
    UILabel *labMemo;
    UILabel *lab_bh;
    UILabel *lab_zcdm;
    UILabel *lab_name;
    UILabel *lab_dz;
    UILabel *lab_time;
    UILabel *lab_id;
    
    UIView *viewThis;
    UIView *viewServer;
    
    UILabel * ser_lab_bh;
    UILabel * ser_lab_zcdm;
    UILabel * ser_lab_name;
    UILabel * ser_lab_dz;
    UILabel * ser_lab_time;
    UILabel * ser_lab_id;
}
@property (nonatomic,strong) AppDelegate *app;
@property (strong, nonatomic) NSString *type;
@end

NS_ASSUME_NONNULL_END
