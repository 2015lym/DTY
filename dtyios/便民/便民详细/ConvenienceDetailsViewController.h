//
//  ConvenienceDetailsViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/8/12.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "UIViewControllerEx.h"
#import "UITableViewExViewController.h"
#import "ClassIfication.h"
#import "ClassIficationEx.h"
#import "FacListViewController.h"
@interface ConvenienceDetailsViewController : UIViewControllerEx<ClassIficationDelegate,ClassIficationExDelegate,SchoolCourseDelegate>
{
    IBOutlet UILabel *lab_condition01;
    IBOutlet UILabel *lab_condition02;
    IBOutlet UILabel *lab_condition03;
    IBOutlet UILabel *lab_condition04;
    IBOutlet UIView *view_Content;
    IBOutlet UIView *view_top;
    UITableViewExViewController *tab_Details;
    ClassIfication *view_ification_01;
    ClassIfication *view_ification_02;
    ClassIficationEx *view_ification_03;
    ClassIfication *view_ification_04;
    
    
    __weak IBOutlet UIButton *btnType;
    
    
    NSMutableArray *_allTypes;
    NSMutableArray *_allcondition04;
    NSString *str_CachePath_FacTypeAll;
    FacListViewController *scvc;
}
@property(nonatomic,strong)NSMutableArray *_allCity;
@property(nonatomic)int selectType;
@property(nonatomic,strong)NSMutableDictionary *currTag;
@end
