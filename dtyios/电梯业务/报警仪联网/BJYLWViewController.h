//
//  BJYLWViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/12/23.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "ClassIfication.h"
#import "CurriculumEntity.h"
#import "mySelect.h"
@interface BJYLWViewController : UIViewControllerEx<UITableViewExViewDelegate,ClassIficationDelegate>
{
    ClassIfication *view_ification_02;
    UITableViewExViewController *CourseTableview;
    mySelect *mySelectView;
}

@property (nonatomic,strong) AppDelegate *app;

//tab about
@property (weak, nonatomic) IBOutlet UILabel *tab_lblSBAZ;
@property (weak, nonatomic) IBOutlet UILabel *tab_LWZT;
@property (weak, nonatomic) IBOutlet UILabel *tab_line;
@property (weak, nonatomic) IBOutlet UILabel *tab_lineSelect;
@property (weak, nonatomic) IBOutlet UIButton *tab_btnSBAZ;
@property (weak, nonatomic) IBOutlet UIButton *tab_btnLWZT;
- (IBAction)tab_btnSBAZClick:(id)sender;
- (IBAction)tab_btnLWZTClick:(id)sender;
//tab about end


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


//tab1
@property (weak, nonatomic) IBOutlet UIScrollView *view1List;
@property (weak, nonatomic) IBOutlet UIView *view1Head;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIImageView *chart1;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelect;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
- (IBAction)btnSelectClick:(id)sender;

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

- (IBAction)btnPopClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;
- (IBAction)btnDoClick:(id)sender;
- (IBAction)btnClearClick:(id)sender;

//tab2

//pop
@property (weak, nonatomic) IBOutlet UIView *view_pop;
@property (weak, nonatomic) IBOutlet UIView *view_Content;


@end
