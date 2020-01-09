//
//  ConvenienceDetailsViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/8/12.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "ConvenienceDetailsViewController.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kRestOfHeight (kHeight - 64 - 40 )
@interface ConvenienceDetailsViewController ()

@end

@implementation ConvenienceDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:238/255 green:238/255 blue:238/255 alpha:238/255]];
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 39, bounds_width.size.width,1)];
    image.image=[UIImage imageNamed:@"line01.png"];
    [view_top addSubview:image];
    str_CachePath_FacTypeAll = [NSString stringWithFormat:@"%@%@",[Util GetMyCachesPath],@"FacTypeAll"];
    _allTypes=[NSMutableArray arrayWithContentsOfFile:str_CachePath_FacTypeAll];
    NSString *currStr=[NSString stringWithFormat:@"%d",_selectType];
    //currTag=[self getTagName:currStr];
    lab_condition01.text=[_currTag objectForKey:@"tagName"];
     self.navigationItem.title=lab_condition01.text;
    [self addscvc];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhiCity" object:nil];

}
- (void)tongzhi:(NSNotification *)text{
    NSLog(@"%@",text.userInfo[@"textOne"]);
    NSMutableDictionary *selectCity;
    NSString *city=text.userInfo[@"textOne"];
    
    for (NSMutableDictionary *dic_item0 in __allCity ) {
        
         NSMutableArray *cityList=[NSMutableArray arrayWithArray:[dic_item0 objectForKey:@"cityList"]];
        
        for (NSMutableDictionary *dic_item in cityList ) {
        if([city isEqualToString:[dic_item objectForKey:@"tagName"]])
        {
            selectCity= dic_item;
            lab_condition03.text=city;
            scvc.area=selectCity;
            [scvc  pullUpdateData];
            return;
        }
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@",__allCity);
    
    [[self.tabBarController.navigationController.navigationBar viewWithTag:10000] removeFromSuperview];
   
}

-(void)addscvc
{
    scvc=[[FacListViewController alloc] init];
    scvc.tag=_currTag;//@"-1";
    scvc.view.tag=-1;
    //scvc.dic_school_info=dic_school_info;
    scvc.delegate=self;
    CGRect rect= scvc.view.frame;
    //rect=CGRectMake(kWidth*2, 0, kWidth, kRestOfHeight);
    
    rect=CGRectMake(0, 0, kWidth, kRestOfHeight);
    [scvc.view setFrame:rect];
    //[firstCollection addSubview:scvc.view];
    [view_Content addSubview:scvc.view];
    
}


#pragma mark 第一个按钮事件
-(IBAction)btn_condition01:(id)sender
{
    CGRect rect=view_Content.frame;
    rect.origin.x=0;
    rect.origin.y=0;
    if (view_ification_01!=nil) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=view_ification_01.frame;
            rect.size.height=0;
            view_ification_01.frame=rect;
        } completion:^(BOOL finished) {
            [view_ification_01 removeFromSuperview];
            view_ification_01=nil;
        }];
    }
    else{
        
        [self CloseAllClassIfication];
        CGRect rect=view_Content.frame;
        rect.origin.x=0;
        rect.origin.y=0;
        
        //view_ification_01=[[ClassIfication alloc] initWithFrame:rect ArrList:[self getTagsByArray:_allTypes]];
        view_ification_01=[[ClassIfication alloc] initWithFrame:rect ArrList:[NSMutableArray arrayWithArray:_allTypes]];
        
        view_ification_01.delegate=self;
        rect.size.height=0;
        
        view_ification_01.frame=rect;
        [view_Content addSubview:view_ification_01];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=view_Content.frame;
            rect.origin.y=0;
            view_ification_01.frame=rect;
        } completion:^(BOOL finished) {
            
        }];

        
           }

}


-(id)getTagsByArray:(NSMutableArray *)tags1{
    NSMutableArray *result=[[NSMutableArray alloc]init];
    
    for (NSMutableDictionary *dic_item in tags1     ) {
        
        [result addObject:[dic_item objectForKey:@"tagName"]];
    }
    return result;
}




#pragma mark 第二个按钮事件
-(IBAction)btn_condition02:(id)sender
{
    CGRect rect=view_Content.frame;
    rect.origin.x=0;
    rect.origin.y=0;
    if (view_ification_02!=nil) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=view_ification_02.frame;
            rect.size.height=0;
            view_ification_02.frame=rect;
        } completion:^(BOOL finished) {
            [view_ification_02 removeFromSuperview];
            view_ification_02=nil;
        }];
    }
    else{
        [self CloseAllClassIfication];
        
        NSMutableArray *arr2=[[NSMutableArray alloc]init];
        NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
        [d1 setObject:@"0" forKey:@"tagId"];
        [d1 setObject:@"默认排序" forKey:@"tagName"];
        [arr2 addObject:d1];
        d1 = [NSMutableDictionary dictionaryWithCapacity:2];
        [d1 setObject:@"1" forKey:@"tagId"];
        [d1 setObject:@"离我最近" forKey:@"tagName"];
        [arr2 addObject:d1];
        d1 = [NSMutableDictionary dictionaryWithCapacity:2];
        [d1 setObject:@"2" forKey:@"tagId"];
        [d1 setObject:@"最新发布" forKey:@"tagName"];
        [arr2 addObject:d1];
        view_ification_02=[[ClassIfication alloc] initWithFrame:rect ArrList:[NSMutableArray arrayWithArray:arr2]];
        
        //view_ification_02=[[ClassIfication alloc] initWithFrame:rect ArrList:[NSMutableArray arrayWithObjects:@"默认排序",@"离我最近",@"最新发布", nil]];
        view_ification_02.delegate=self;
        rect.size.height=0;
        
        view_ification_02.frame=rect;
        [view_Content addSubview:view_ification_02];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=view_Content.frame;
            rect.origin.y=0;
            view_ification_02.frame=rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
#pragma mark 第三个按钮事件
-(IBAction)btn_condition03:(id)sender
{
    CGRect rect=view_Content.frame;
    rect.origin.x=0;
    rect.origin.y=0;
    if (view_ification_03!=nil) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=view_ification_03.frame;
            rect.size.height=0;
            view_ification_03.frame=rect;
        } completion:^(BOOL finished) {
            [view_ification_03 removeFromSuperview];
            view_ification_03=nil;
        }];
    }
    else{
        [self CloseAllClassIfication];
        view_ification_03=[[ClassIficationEx alloc] initWithFrame:rect ArrList:[NSMutableArray arrayWithArray:__allCity]];
        view_ification_03.delegate=self;
        rect.size.height=0;
        
        view_ification_03.frame=rect;
        [view_Content addSubview:view_ification_03];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=view_Content.frame;
            rect.origin.y=0;
            view_ification_03.frame=rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
#pragma mark 第四个按钮事件
-(IBAction)btn_condition04:(id)sender
{
    CGRect rect=view_Content.frame;
    rect.origin.x=0;
    rect.origin.y=0;
    if (view_ification_04!=nil) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=view_ification_04.frame;
            rect.size.height=0;
            view_ification_04.frame=rect;
        } completion:^(BOOL finished) {
            [view_ification_04 removeFromSuperview];
            view_ification_04=nil;
        }];
    }
    else{
        [self CloseAllClassIfication];
        view_ification_04=[[ClassIfication alloc] initWithFrame:rect ArrList:[NSMutableArray arrayWithArray:scvc.entity.adver_list]];
        view_ification_04.delegate=self;
        rect.size.height=0;
        
        view_ification_04.frame=rect;
        [view_Content addSubview:view_ification_04];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=view_Content.frame;
            rect.origin.y=0;
            view_ification_04.frame=rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
#pragma mark 关闭所有ClassIfication视图
-(void)CloseAllClassIfication
{
    [view_ification_01 removeFromSuperview];
    [view_ification_02 removeFromSuperview];
    [view_ification_03 removeFromSuperview];
    [view_ification_04 removeFromSuperview];

    view_ification_01=nil;
    view_ification_02=nil;
    view_ification_03=nil;
    view_ification_04=nil;
}
#pragma mark ClassIficationDelegate
-(void)ColesTypeView:(UIView *)typeView
{
    if (typeView ==view_ification_01) {
        //lab_condition01.text=Content;
        if (view_ification_01!=nil) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect=view_ification_01.frame;
                rect.size.height=0;
                view_ification_01.frame=rect;
            } completion:^(BOOL finished) {
                [view_ification_01 removeFromSuperview];
                view_ification_01=nil;
            }];
        }
    }
    else if(typeView ==view_ification_02)
    {
        if (view_ification_02!=nil) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect=view_ification_02.frame;
                rect.size.height=0;
                view_ification_02.frame=rect;
            } completion:^(BOOL finished) {
                [view_ification_02 removeFromSuperview];
                view_ification_02=nil;
            }];
        }
    }
    else if(typeView ==view_ification_03)
    {
        if (view_ification_03!=nil) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect=view_ification_03.frame;
                rect.size.height=0;
                view_ification_03.frame=rect;
            } completion:^(BOOL finished) {
                [view_ification_03 removeFromSuperview];
                view_ification_02=nil;
            }];
        }
    }
    else if(typeView ==view_ification_04)
    {
        if (view_ification_04!=nil) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect=view_ification_04.frame;
                rect.size.height=0;
                view_ification_04.frame=rect;
            } completion:^(BOOL finished) {
                [view_ification_04 removeFromSuperview];
                view_ification_04=nil;
            }];
        }
    }

}
-(void)Cell_OnClick:(id)Content typeView:(UIView *)typeView
{
    if (typeView ==view_ification_01) {
        //lab_condition01.text=Content;
        lab_condition01.text=[Content objectForKey:@"tagName"];
        if (view_ification_01!=nil) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect=view_ification_01.frame;
                rect.size.height=0;
                view_ification_01.frame=rect;
            } completion:^(BOOL finished) {
                [view_ification_01 removeFromSuperview];
                view_ification_01=nil;
            }];
        }
        
         self.navigationItem.title=lab_condition01.text;
        scvc.tag=Content;
        scvc.types=nil;
        lab_condition04.text=@"分类";
        [scvc  pullUpdateData];
    }
    else if(typeView ==view_ification_02)
    {
        //lab_condition02.text=Content;
        lab_condition02.text=[Content objectForKey:@"tagName"];
        if (view_ification_02!=nil) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect=view_ification_02.frame;
                rect.size.height=0;
                view_ification_02.frame=rect;
            } completion:^(BOOL finished) {
                [view_ification_02 removeFromSuperview];
                view_ification_02=nil;
            }];
        }
        
        scvc.sort=Content;
        [scvc  pullUpdateData];
    }
    else if(typeView ==view_ification_03)
    {
        lab_condition03.text=[Content objectForKey:@"tagName"];
        if (view_ification_03!=nil) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect=view_ification_03.frame;
                rect.size.height=0;
                view_ification_03.frame=rect;
            } completion:^(BOOL finished) {
                [view_ification_03 removeFromSuperview];
                view_ification_02=nil;
            }];
        }
        
        scvc.area=Content;
        [scvc  pullUpdateData];

    }
    else if(typeView ==view_ification_04)
    {
        lab_condition04.text=[Content objectForKey:@"tagName"];
        if (view_ification_04!=nil) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect=view_ification_04.frame;
                rect.size.height=0;
                view_ification_04.frame=rect;
            } completion:^(BOOL finished) {
                [view_ification_04 removeFromSuperview];
                view_ification_04=nil;
            }];
        }
        
        scvc.types=Content;
        [scvc  pullUpdateData];
        
    }
}

#pragma 弹出名细页面
-(void)SchoolCoursePush:(UIViewControllerEx *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
