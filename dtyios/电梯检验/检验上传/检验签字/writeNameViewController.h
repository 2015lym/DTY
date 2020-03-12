//
//  writeNameViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/7/18.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "ClassIfication.h"
#import "CurriculumEntity.h"


#import "MyControl.h"
#import "HQDrawingView.h"
#import "warningElevatorModel.h"

@interface writeNameViewController : UIViewControllerEx<UITableViewExViewDelegate,ClassIficationDelegate>
{
    ClassIfication *view_ification_02;
    UIView *_view_pop;
    UIView *_view_Content;
    UILabel *shi_labDetail;
    UILabel *shi_lab;
    UIButton *shi_labBtn;
    
    BOOL isfirstLoad;
    
    NSString *resurtdian;
    
    NSString* type;
}

@property (nonatomic,strong) AppDelegate *app;

@property (nonatomic,strong) NSString *lift_ID;

@property (nonatomic,strong) warningElevatorModel *dataDic;
@property (nonatomic,retain) NSString *from;

@property (nonatomic,retain) NSString *TypeID;
@property (nonatomic,retain) NSString *TypeName;

@end
