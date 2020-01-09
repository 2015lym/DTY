//
//  helpInfoViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/10.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "helpInfoViewController.h"
//#import "NSString+extention.swift"
#import "MyControl.h"
@interface helpInfoViewController ()
{
NSString * strPhone;
}
@end

@implementation helpInfoViewController
-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    [[self.tabBarController.navigationController.navigationBar viewWithTag:10000] removeFromSuperview];
    self.navigationItem.title=@"救援信息";

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _labInstallationAddress.frame=CGRectMake(_labInstallationAddress.frame.origin.x, _labInstallationAddress.frame.origin.y, bounds_width.size.width-_labInstallationAddress.frame.origin.x-10, _labInstallationAddress.frame.size.height+5);
    _viewBlue.layer.masksToBounds = YES; //没这句话它圆不起来
    _viewBlue.layer.cornerRadius = 5; //设置图片圆角的尺度
    
    _viewIcon.layer.masksToBounds = YES; //没这句话它圆不起来
    _viewIcon.layer.cornerRadius = 12; //设置图片圆角的尺度
    
   
    _labNum.text=_warnModel.Lift.LiftNum;
    _labTatolTime.text=[_warnModel.TotalLossTime stringByAppendingString:@"分"];
    
    if(![_warnModel.StatusName isEqual:@"<null>"])
        _lblSatus.text=_warnModel.StatusName;
    else
      _lblSatus.text=@"";
    
    _lblSatus.frame=CGRectMake(_lblSatus.frame.origin
                               .x, _lblSatus.frame.origin.y,bounds_width.size.width -111, _lblSatus.frame.size.height);
    
    
    
    
    self.view.frame=CGRectMake(0, 0,bounds_width.size.width , bounds_width.size.height);
    
    //init
    UIScrollView *sc=[[UIScrollView alloc]init];
    sc.frame=CGRectMake(0, 0,bounds_width.size.width , bounds_width.size.height);
    [self.view addSubview:sc];
    CGSize size;
    size.width = bounds_width.size.width;
    size.height =640+147+10;// bounds_width.size.height-_viewHeader.frame.size.height;
    sc.contentSize = size;
    
    [sc addSubview:_viewHeader];
    [sc addSubview:_viewBase];
    
    //1.header
    _viewHeader.frame=CGRectMake(0, 0,bounds_width.size.width , _viewHeader.frame.size.height);
    
   
    //1.1
    float width2=bounds_width.size.width/2;
    UILabel *lab1=[MyControl createLabelWithFrame:CGRectMake(0, 10, width2, 20) Font:14 Text:@"电梯编号"];
    lab1 .textAlignment=NSTextAlignmentCenter;
    lab1.textColor=[UIColor grayColor];
    [_viewHeader addSubview:lab1];
    _labNum.frame=CGRectMake(0, 30, width2, 20);
    _labNum .textAlignment=NSTextAlignmentCenter;
    
    UILabel *labLine1=[MyControl createLabelWithFrame:CGRectMake(width2, 20, 1, 25) Font:14 Text:@""];
    labLine1.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_viewHeader addSubview:labLine1];

    //1.2
    UILabel *lab2=[MyControl createLabelWithFrame:CGRectMake(width2+1, 10, width2, 20) Font:14 Text:@"总时间"];
    lab2 .textAlignment=NSTextAlignmentCenter;
    lab2.textColor=[UIColor grayColor];
    [_viewHeader addSubview:lab2];
    _labTatolTime.frame=CGRectMake(width2+1, 30, width2, 20);
    _labTatolTime .textAlignment=NSTextAlignmentCenter;
    
    UILabel *labLine2=[MyControl createLabelWithFrame:CGRectMake(0, 60, bounds_width.size.width, 1) Font:14 Text:@""];
    labLine2.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_viewHeader addSubview:labLine2];
    
    //2.
    //2.0
    UIView *viewBaseH=[[UIView alloc]initWithFrame:CGRectMake(0, 106, bounds_width.size.width, 40)];
    viewBaseH.backgroundColor=[UIColor whiteColor];
    [sc addSubview:viewBaseH];
    
    UIImageView * img=[MyControl createImageViewWithFrame:CGRectMake(10, 13, 5, 14) imageName:@"decorate_blue"];
    [viewBaseH addSubview:img];

    UILabel *lab3=[MyControl createLabelWithFrame:CGRectMake(30, 10, width2, 20) Font:14 Text:@"电梯信息"];
    [viewBaseH addSubview:lab3];
    
    UILabel *labLine4=[MyControl createLabelWithFrame:CGRectMake(0, 39, bounds_width.size.width, 1) Font:14 Text:@""];
    labLine4.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [viewBaseH addSubview:labLine4];
    
    //2.1
     _viewBase.frame=CGRectMake(0, 146,bounds_width.size.width ,bounds_width.size.height- _viewHeader.frame.size.height+50);
    
    
    //bind
    if(![_warnModel.Lift.LiftNum isEqual:@"<null>"])
    _labLiftNum.text=_warnModel.Lift.LiftNum;
     if(![_warnModel.Lift.CertificateNum isEqual:@"<null>"])
    _labCertificateNum.text=_warnModel.Lift.CertificateNum;
     if(![_warnModel.Lift.MachineNum isEqual:@"<null>"])
    _labMachineNum.text=_warnModel.Lift.MachineNum;
     if(![_warnModel.Lift.CustomNum isEqual:@"<null>"])
    _labCustomNum.text=_warnModel.Lift.CustomNum;
     if(![_warnModel.Lift.Brand isEqual:@"<null>"])
    _labBrand.text=_warnModel.Lift.Brand;
     if(![_warnModel.Lift.Model isEqual:@"<null>"])
     _labModel.text=_warnModel.Lift.Model;
     if(![_warnModel.Lift.InstallationAddress isEqual:@"<null>"])
    _labInstallationAddress.text=_warnModel.Lift.InstallationAddress;
    //年检日期
    _labDictName.text=_warnModel.Lift.LiftSiteDict;
    _LiftType.text=_warnModel.Lift.LiftTypeDict;
    _labUseDepartment.text=_warnModel.Lift.UseDepartment;
    
    int lastHeight=268;//_viewBase.frame.origin.y+_viewBase.frame.size.height;
    lastHeight=[self addUser:lastHeight forLabel:@"管理人员:" forData:_warnModel.Lift.UseUsers];
    lastHeight=[self addInfo:lastHeight forLabel:@"维保单位:" forData: _warnModel.Lift.MaintenanceDepartment];
    lastHeight=[self addUser:lastHeight forLabel:@"维保人员:" forData:_warnModel.Lift.MaintUsers];
    
    
    UILabel *labLine40=[MyControl createLabelWithFrame:CGRectMake(0, lastHeight, bounds_width.size.width, 10) Font:14 Text:@""];
    labLine40.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_viewBase addSubview:labLine40];
    
    UIView *viewBaseH1=[[UIView alloc]initWithFrame:CGRectMake(0, lastHeight+10, bounds_width.size.width, 40)];
    viewBaseH1.backgroundColor=[UIColor whiteColor];
    [_viewBase addSubview:viewBaseH1];
    
    UIImageView * img1=[MyControl createImageViewWithFrame:CGRectMake(10, 13, 5, 14) imageName:@"decorate_blue"];
    [viewBaseH1 addSubview:img1];
    
    UILabel *lab31=[MyControl createLabelWithFrame:CGRectMake(30, 10, width2, 20) Font:14 Text:@"报警信息"];
    [viewBaseH1 addSubview:lab31];
    
    UILabel *labLine41=[MyControl createLabelWithFrame:CGRectMake(0, 39, bounds_width.size.width, 1) Font:14 Text:@""];
    labLine41.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [viewBaseH1 addSubview:labLine41];
    
    lastHeight=lastHeight+50;
    
    lastHeight=[self addInfo:lastHeight forLabel:@"报警时间:" forData:_warnModel.CreateTime];
    lastHeight=[self addInfo:lastHeight forLabel:@"任务来源:"  forData: _warnModel.SourceDict];
    lastHeight=[self addInfo:lastHeight forLabel:@"被困人数:"  forData: _warnModel.RescueNumber];
    lastHeight=[self addInfo:lastHeight forLabel:@"联系电话:"  forData: _warnModel.RescuePhone];
    lastHeight=[self addInfo:lastHeight forLabel:@"任务备注:"  forData: _warnModel.Content];
    strPhone=_warnModel.RemedyUserPhone;
    lastHeight=[self addInfo:lastHeight forLabel:@"救援人员:"  forData: _warnModel.RemedyUser];
    lastHeight=[self addInfo:lastHeight forLabel:@"完成时间:"  forData: _warnModel.RescueCompleteTime];
}

-(int)addInfo:(int)lastHeight forLabel:(NSString*)Label forData:(NSString*)info {
    //管理人员
    
    UIView *viewUseUser=[[UIView alloc]init];
    viewUseUser.frame=CGRectMake(3, lastHeight, bounds_width.size.width, 21);
    UILabel *label=[[UILabel alloc]init];
    label.text=Label;
    [label setFont:[UIFont systemFontOfSize:14]];
    label.frame=CGRectMake(0, 0, bounds_width.size.width,21);
    [viewUseUser addSubview:label];
    
    UILabel *currLabel=[[UILabel alloc]init];
    [currLabel setFont:[UIFont systemFontOfSize:14]];
    
    //得到标签的宽度
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0f]};
    CGRect rect = [info boundingRectWithSize:CGSizeMake(320.f, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    
    
    currLabel.frame=CGRectMake(71, 0, rect.size.width+20,21);
    
    if(![info isEqual:@"<null>"])
    {
    currLabel.text = info;
    if([Label isEqual:@"救援人员:"])
        {
            if(!(strPhone ==nil))
            {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateSelected];
            btn.frame=CGRectMake(currLabel.frame.origin.x+currLabel.frame.size.width, 0, 21,21);
                btn.tag=[strPhone longLongValue];

            [btn addTarget:self action:@selector(addClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [viewUseUser addSubview:btn];
        }
        }
        if([Label isEqual:@"联系电话:"])
        {
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateSelected];
            btn.frame=CGRectMake(currLabel.frame.origin.x+currLabel.frame.size.width, 0, 21,21);
            btn.tag=[info longLongValue];
            
            [btn addTarget:self action:@selector(addClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [viewUseUser addSubview:btn];
            
        }

    }
    
    [viewUseUser addSubview:currLabel];
    
    //[self.view addSubview:viewUseUser];
    [_viewBase addSubview:viewUseUser];
    return viewUseUser.frame.origin.y+viewUseUser.frame.size.height;
}

// MARK: - UIButton点击事件
-(void)  addClickBtn:(UIButton *)btn {
    
    /*
    if btn.tag >= 100 {
        let url1 = NSURL(string: "tel://" + "\((managerArr?.Lift?.MaintUsersArrs[btn.tag - 100].Mobile)!)")
        UIApplication.sharedApplication().openURL(url1!)
    }
    else{
        let url2 = NSURL(string: "tel://" + "\((managerArr?.Lift?.UseUsersArrs[btn.tag].Mobile)!)")
        UIApplication.sharedApplication().openURL(url2!)
    }
     */
    //NSString *srt_url=[NSString stringWithFormat:@"tel://%ld", btn.tag];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:srt_url]];
    NSString *srt_url=[NSString stringWithFormat:@"tel://%ld", btn.tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:srt_url]];

}



-(int)addUser:(int)lastHeight forLabel:(NSString*)Label forData:(NSMutableArray*)array{
    //管理人员
    
    UIView *viewUseUser=[[UIView alloc]init];
    UILabel *label=[[UILabel alloc]init];
    label.text=Label;
    [label setFont:[UIFont systemFontOfSize:14]];
    label.frame=CGRectMake(3, 0, bounds_width.size.width,21);
    [viewUseUser addSubview:label];
    
    if(array.count!=0)
    {
        int i=0;
        viewUseUser.frame=CGRectMake(0, lastHeight, bounds_width.size.width, array.count*21);
        for (NSMutableDictionary *dic_item in array )
        {
            UILabel *currLabel=[[UILabel alloc]init];
            [currLabel setFont:[UIFont systemFontOfSize:14]];
                        NSString *userName=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"UserName"]];
            NSString *Mobile=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"Mobile"]];
            currLabel.text = [userName stringByAppendingString:@"("];
            currLabel.text = [currLabel.text stringByAppendingString:Mobile];
            currLabel.text = [currLabel.text stringByAppendingString:@")"];
            
            //得到标签的宽度
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0f]};
            CGRect rect = [currLabel.text boundingRectWithSize:CGSizeMake(320.f, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
            
            currLabel.frame=CGRectMake(71, i*21, rect.size.width+20,21);

            if(![Mobile  isEqual:@"<null>"])
            {
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateSelected];
                btn.frame=CGRectMake(currLabel.frame.origin.x+currLabel.frame.size.width, currLabel.frame.origin.y, 21,21);
                btn.tag=[Mobile longLongValue];
                
                [btn addTarget:self action:@selector(addClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [viewUseUser addSubview:btn];
            }

            
            
            [viewUseUser addSubview:currLabel];
            
            i=i+1;
        }
    }
    else
    {
        viewUseUser.frame=CGRectMake(0, lastHeight, bounds_width.size.width, 21);
    }
    //[self.view addSubview:viewUseUser];
    [_viewBase addSubview:viewUseUser];
  return viewUseUser.frame.origin.y+viewUseUser.frame.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
