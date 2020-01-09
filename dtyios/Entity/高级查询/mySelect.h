//
//  mySelect.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/8.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "appDelegate.h"
#import "ClassIfication.h"
#import "CurriculumEntity.h"
#import "MyControl.h"
@interface mySelect  : UIViewControllerEx<ClassIficationDelegate>
{
    ClassIfication *view_ification_02;
    
}

@property (nonatomic,strong) AppDelegate *app;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIView *viewSelect;
@property (weak, nonatomic) IBOutlet UILabel *lblState;

@property (weak, nonatomic) IBOutlet UILabel *lblQu;

@property (weak, nonatomic) IBOutlet UILabel *txtCity;
@property (weak, nonatomic) IBOutlet UILabel *txtQu;
@property (weak, nonatomic) IBOutlet UILabel *txtUserDept;
@property (weak, nonatomic) IBOutlet UILabel *txtMaintDept;
@property (weak, nonatomic) IBOutlet UILabel *txtState;
@property (weak, nonatomic) IBOutlet UIButton *btnCity;
@property (weak, nonatomic) IBOutlet UIButton *btnQu;
@property (weak, nonatomic) IBOutlet UIButton *btnUserDept;
@property (weak, nonatomic) IBOutlet UIButton *btnMaintDept;
@property (weak, nonatomic) IBOutlet UIButton *btnState;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDo;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;


@property (weak, nonatomic) IBOutlet UIImageView * imgCity;
@property (weak, nonatomic) IBOutlet UIImageView * imgQu;
@property (weak, nonatomic) IBOutlet UIImageView * imgUserDept;
@property (weak, nonatomic) IBOutlet UIImageView * imgMaintDept;
@property (weak, nonatomic) IBOutlet UIImageView * imgState;

- (IBAction)btnPopClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;
- (IBAction)btnDoClick:(id)sender;
- (IBAction)btnClearClick:(id)sender;

//tab2

//pop
@property (weak, nonatomic) IBOutlet UIView *view_pop;
@property (weak, nonatomic) IBOutlet UIView *view_Content;

//报警仪联网
@property ( nonatomic)  int  tabSelectIndex;
- (void)initSelect;
@property ( nonatomic)  int  isHaveState;
@property (weak, nonatomic)  NSString *  stateAll;

//屏蔽
@property ( nonatomic)  int  isPB;
@end
