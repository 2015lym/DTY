//
//  handleDetailViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/12/18.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "handleDetailViewController.h"

#import "MBProgressHUD+Add.h"
#import "appDelegate.h"
#import "CommonUseClass.h"
@interface handleDetailViewController ()
{
    NSString * strPhone;
}
@end

@implementation handleDetailViewController
-(void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title=@"处置记录详情";
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     _mapView.showMapScaleBar = YES;
    _labInstallationAddress.frame=CGRectMake(_labInstallationAddress.frame.origin.x, _labInstallationAddress.frame.origin.y, bounds_width.size.width-_labInstallationAddress.frame.origin.x-10, _labInstallationAddress.frame.size.height+5);
    /*
    _mapView.layer.masksToBounds = YES; //没这句话它圆不起来
    _mapView.layer.cornerRadius = 5; //设置图片圆角的尺度
    
    _viewInfo1.layer.masksToBounds = YES; //没这句话它圆不起来
    _viewInfo1.layer.cornerRadius = 5; //设置图片圆角的尺度
    
    _viewInfo2.layer.masksToBounds = YES; //没这句话它圆不起来
    _viewInfo2.layer.cornerRadius = 5; //设置图片圆角的尺度
   
    _mapView.layer.shadowOpacity = 0.5;// 阴影透明度
    _mapView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    _mapView.layer.shadowRadius = 5;// 阴影扩散的范围控制
    _mapView.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
    _mapView.layer.borderWidth = 1;
    _mapView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
     */
    
    [ self requestOneBignNeedleByID:_warnModel.ID];
    // Do any additional setup after loading the view.
    _scrollView.frame=CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height);

    _mapView.frame=CGRectMake(0, 0, bounds_width.size.width, 200);
    //1.1
    UIView *viewBaseH=[[UIView alloc]initWithFrame:CGRectMake(0, 200, bounds_width.size.width, 40)];
    viewBaseH.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:viewBaseH];
    
    UIImageView * img=[MyControl createImageViewWithFrame:CGRectMake(10, 13, 5, 14) imageName:@"decorate_blue"];
    [viewBaseH addSubview:img];
    
    UILabel *lab3=[MyControl createLabelWithFrame:CGRectMake(30, 10, 100, 20) Font:14 Text:@"救援信息"];
    [viewBaseH addSubview:lab3];
    
    UILabel *labLine4=[MyControl createLabelWithFrame:CGRectMake(0, 39, bounds_width.size.width, 1) Font:14 Text:@""];
    labLine4.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [viewBaseH addSubview:labLine4];

    
    _viewInfo1.frame=CGRectMake(0, 240, bounds_width.size.width, 220);
    
    //1.1
    UIView *viewBaseH1=[[UIView alloc]initWithFrame:CGRectMake(0, 465, bounds_width.size.width, 40)];
    viewBaseH1.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:viewBaseH1];
    
    UIImageView * img1=[MyControl createImageViewWithFrame:CGRectMake(10, 13, 5, 14) imageName:@"decorate_blue"];
    [viewBaseH1 addSubview:img1];
    
    UILabel *lab31=[MyControl createLabelWithFrame:CGRectMake(30, 10, 100, 20) Font:14 Text:@"电梯信息"];
    [viewBaseH1 addSubview:lab31];
    
    UILabel *labLine41=[MyControl createLabelWithFrame:CGRectMake(0, 39, bounds_width.size.width, 1) Font:14 Text:@""];
    labLine41.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [viewBaseH1 addSubview:labLine41];
    
    _viewInfo2.frame=CGRectMake(0, 505, bounds_width.size.width, 272);
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OneBignNeedle:(warningElevatorModel *) _warningElevatorModel{
    //1
    [self PointAnnotationAdd:_warningElevatorModel forZoom:15];
    
    //2
    _lbl_state.text=_warningElevatorModel.StatusName;
    _RescueType.text=[CommonUseClass GetRescueTypeName:_warningElevatorModel.RescueType]  ;
    _RemedyUser.text=_warningElevatorModel.RemedyUser;
    
    if(!([[CommonUseClass FormatString:_warningElevatorModel.RemedyUserPhone]  isEqual:@""]))
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateSelected];
        btn.frame=CGRectMake(230, 53, 21,21);
        btn.tag=[_warningElevatorModel.RemedyUserPhone longLongValue];
        
        [btn addTarget:self action:@selector(addClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_viewInfo1 addSubview:btn];
    }

    _compary.text=_warningElevatorModel.RemedyUserDeptName;
    _time1.text=_warningElevatorModel.CreateTime;
    _time2.text= [CommonUseClass FormatString: _warningElevatorModel.UseConfirmTime];
    _time3.text=_warningElevatorModel.MaintConfirmTime;
    _time4.text=_warningElevatorModel.MaintArriveTime;
    _time5.text=_warningElevatorModel.RescueCompleteTime;
    
    //3
    _warnModel=_warningElevatorModel;
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
    //lastHeight=[self addInfo:lastHeight forLabel:@"报警时间:" forData:_warnModel.CreateTime];
    
    //1.1
    UILabel *labLine41=[MyControl createLabelWithFrame:CGRectMake(0, lastHeight, bounds_width.size.width, 5) Font:14 Text:@""];
    labLine41.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_viewInfo2 addSubview:labLine41];
    
    UIView *viewBaseH=[[UIView alloc]initWithFrame:CGRectMake(0, lastHeight+5, bounds_width.size.width, 40)];
    viewBaseH.backgroundColor=[UIColor whiteColor];
    [_viewInfo2 addSubview:viewBaseH];
    
    UIImageView * img=[MyControl createImageViewWithFrame:CGRectMake(10, 13, 5, 14) imageName:@"decorate_blue"];
    [viewBaseH addSubview:img];
    
    UILabel *lab3=[MyControl createLabelWithFrame:CGRectMake(30, 10, 100, 20) Font:14 Text:@"报警信息"];
    [viewBaseH addSubview:lab3];
    
    UILabel *labLine4=[MyControl createLabelWithFrame:CGRectMake(0, 39, bounds_width.size.width, 1) Font:14 Text:@""];
    labLine4.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [viewBaseH addSubview:labLine4];
    lastHeight+=45;

    
    
    lastHeight=[self addInfo:lastHeight forLabel:@"任务来源:"  forData: _warnModel.SourceDict];
    lastHeight=[self addInfo:lastHeight forLabel:@"被困人数:"  forData: _warnModel.RescueNumber];
    lastHeight=[self addInfo:lastHeight forLabel:@"联系电话:"  forData: _warnModel.RescuePhone];
    lastHeight=[self addInfo:lastHeight forLabel:@"任务备注:"  forData: _warnModel.Content];
    strPhone=_warnModel.RemedyUserPhone;
    lastHeight=[self addInfo:lastHeight forLabel:@"故障原因:"  forData: _warnModel.ReasonDict];
    lastHeight=[self addInfo:lastHeight forLabel:@"救援方法:"  forData: _warnModel.RemedyDict];
    
    _viewInfo2.frame=CGRectMake(0, 505, bounds_width.size.width, lastHeight);
    
    CGSize size;
    size.width = bounds_width.size.width;
    size.height =505+lastHeight+75;
    _scrollView.contentSize = size;
}

// MARK: - UIButton点击事件
-(void) addClickBtn:(UIButton *)btn {
    
    
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
            if(![Mobile  isEqual:@"<null>"]&&![Mobile  isEqual:@""])
            {
            currLabel.text = [userName stringByAppendingString:@"("];
            currLabel.text = [currLabel.text stringByAppendingString:Mobile];
            currLabel.text = [currLabel.text stringByAppendingString:@")"];
            }else
            {
                currLabel.text = userName;
            }
                              
            
            //得到标签的宽度
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0f]};
            CGRect rect = [currLabel.text boundingRectWithSize:CGSizeMake(320.f, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:attributes
                                                       context:nil];
            
            currLabel.frame=CGRectMake(71, i*21, rect.size.width+20,21);
            
            if(![Mobile  isEqual:@"<null>"]&&![Mobile  isEqual:@""])
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
    [_viewInfo2 addSubview:viewUseUser];
    return viewUseUser.frame.origin.y+viewUseUser.frame.size.height;
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
    [_viewInfo2 addSubview:viewUseUser];
    return viewUseUser.frame.origin.y+viewUseUser.frame.size.height;
}

//添加一个地图点
-(void)PointAnnotationAdd:(warningElevatorModel*)model forZoom:(int)zoom
{
    NSArray *s = [model.Lift.BaiduMapXY componentsSeparatedByString:@","];
    if(![self isBlankString :model.Lift.BaiduMapXY] &&s.count==2){
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
        double f0=[[s objectAtIndex:0] doubleValue];
        double f1=[[s objectAtIndex:1] doubleValue];
        
        NSLog(@"%ld==%ld",f0,f1);
        
        
        CLLocationCoordinate2D coor=CLLocationCoordinate2DMake(f1, f0);
        if(zoom==0)
        {
            BMKCoordinateSpan span;
            //计算地理位置的跨度
            span.latitudeDelta = 10.0f;
            span.longitudeDelta = 10.0f;
            //得出数据的坐标区域
            BMKCoordinateRegion viewRegion ;
            viewRegion.center=coor;
            viewRegion.span=span;
            
            _mapView.region=viewRegion;
        }
        else
        {
            //得出数据的坐标区域
            BMKCoordinateRegion viewRegion ;
            viewRegion.center=coor;
            
            
            _mapView.region=viewRegion;
            
            [_mapView setZoomEnabled:YES];
            [_mapView setZoomLevel:19];
            
            
        }
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = model.Lift.LiftNum;
        //pointAnnotation.subtitle = model.Lift.InstallationAddress;
        
        NSString *str=@"1,";//1为电梯2为维保
        str=[str stringByAppendingString:model.Lift.LiftNum];
        str=[str stringByAppendingString:@","];
        str=[str stringByAppendingString:model.Lift.InstallationAddress];
        pointAnnotation.subtitle =str;
        
        [_mapView addAnnotation:pointAnnotation];
    }
    else
    {
        //[MBProgressHUD showError:@"有一条纪录无坐标信息!" toView:nil];
    }
    
}


// MARK:- 一个大头针的网络请求数据闭包调用方法
- (void)requestOneBignNeedleByID: (NSString *)TaskID
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *string = [@"Task/GetTask?id=" stringByAppendingString:TaskID];
    [[AFAppDotNetAPIClient sharedClient]
     GET:string
     
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"state"] intValue];
             if (state_value==0) {
                 NSDictionary* dic_item=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 
                 //warningElevatorModel
                 warningElevatorModel *model=[[warningElevatorModel alloc] init];
                 model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"CreateTime"]];
                 model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                 model.LiftId=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"LiftId"]] ;
                 NSDictionary* dic_item3=[dic_item objectForKey:@"Lift"];
                 warningElevatorLift *lift=[[warningElevatorLift alloc]init];
                 lift.BaiduMapXY=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"BaiduMapXY"]];
                 lift.BaiduMapZoom=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"BaiduMapZoom"]];
                 lift.LiftNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"LiftNum"]];
                 lift.InstallationAddress=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"InstallationAddress"]];
                 lift.AddressPath=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"AddressPath"]];
                 model.Lift=lift;
                 model.StatusName=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"StatusName"]];
                 if([model.StatusName isEqual:@"<null>"])
                 {model.StatusName=@"";}

                 model.StatusId=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"StatusId"]];
                 model.RescueType=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescueType"]];
                 model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"TotalLossTime"]];
                 model.MaintArriveTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"MaintArriveTime"]];
                 
                 //选择一个大头针
                 lift.CertificateNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"CertificateNum"]];
                 lift.MachineNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"MachineNum"]];
                 lift.CustomNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"CustomNum"]];
                 lift.Brand=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"Brand"]];
                 lift.Model=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"Model"]];
                 
                 
                 //使用场所
                 NSString* arr_LiftSiteDict=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"LiftSiteDict"]];
                 if(![arr_LiftSiteDict isEqual:@"<null>"])
                 {
                     NSDictionary* dic_LiftSiteDict=[dic_item3 objectForKey:@"LiftSiteDict"];
                     lift.LiftSiteDict=[NSString stringWithFormat:@"%@",[dic_LiftSiteDict objectForKey:@"DictName"]];
                 }
                 
                 
                 //电梯类型
                 NSString* arr_LiftTypeDict=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"LiftTypeDict"]];
                 if(![arr_LiftTypeDict isEqual:@"<null>"])
                 {
                     NSDictionary* dic_LiftTypeDict=[dic_item3 objectForKey:@"LiftTypeDict"];
                     lift.LiftTypeDict=[NSString stringWithFormat:@"%@",[dic_LiftTypeDict objectForKey:@"DictName"]];
                 }
                 
                 //使用单位
                 NSString* arr_UseDepartment=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"UseDepartment"]];
                 if(![arr_UseDepartment isEqual:@"<null>"])
                 {
                     NSDictionary* dic_UseDepartment=[dic_item3 objectForKey:@"UseDepartment"];
                     lift.UseDepartment=[NSString stringWithFormat:@"%@",[dic_UseDepartment objectForKey:@"DeptName"]];
                 }
                 //管理人员
                 lift.UseUsers=[dic_item3 objectForKey:@"UseUsers"];
                 //维保人员
                 lift.MaintUsers=[dic_item3 objectForKey:@"MaintUsers"];
                 
                 //维保单位
                 NSString* arr_MaintenanceDepartment=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"MaintenanceDepartment"]];
                 if(![arr_MaintenanceDepartment isEqual:@"<null>"])
                 {
                     NSDictionary* dic_MaintenanceDepartment=[dic_item3 objectForKey:@"MaintenanceDepartment"];
                     lift.MaintenanceDepartment=[NSString stringWithFormat:@"%@",[dic_MaintenanceDepartment objectForKey:@"DeptName"]];
                 }
                 //任务来源
                 NSString* arr_SourceDict=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"SourceDict"]];
                 if(![arr_SourceDict isEqual:@"<null>"])
                 {
                     NSDictionary* dic_SourceDict=[dic_item objectForKey:@"SourceDict"];
                     model.SourceDict=[NSString stringWithFormat:@"%@",[dic_SourceDict objectForKey:@"DictName"]];
                 }
                 //救援人员
                 NSString* arr_RemedyUser=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RemedyUser"]];
                 if(![arr_RemedyUser isEqual:@"<null>"])
                 {
                     NSDictionary* dic_RemedyUser=[dic_item objectForKey:@"RemedyUser"];
                     
                     NSString *userName=[NSString stringWithFormat:@"%@",[dic_RemedyUser objectForKey:@"UserName"]];
                     NSString *Mobile=[NSString stringWithFormat:@"%@",[dic_RemedyUser objectForKey:@"Mobile"]];
                     model.RemedyUserPhone=Mobile;
                     if(![model.RemedyUserPhone isEqual:@"<null>"]&&![model.RemedyUserPhone isEqual:@""])
                     {
                     model.RemedyUser = [userName stringByAppendingString:@"("];
                     model.RemedyUser  = [model.RemedyUser  stringByAppendingString:Mobile];
                     model.RemedyUser  = [model.RemedyUser  stringByAppendingString:@")"];
                     }
                     model.RemedyUserId=[dic_item objectForKey:@"ID"];
                     
                     NSString* arr_RemedyUserDept=[NSString stringWithFormat:@"%@",[dic_RemedyUser objectForKey:@"Dept"]];
                     if(![arr_RemedyUserDept isEqual:@"<null>"])
                     {
                         NSDictionary* dic_RemedyUserDept=[dic_RemedyUser objectForKey:@"Dept"];
                         
                         model.RemedyUserDeptName=[NSString stringWithFormat:@"%@",[dic_RemedyUserDept objectForKey:@"DeptName"]];
                     }
                 }
                 
                 //故障原因
                 NSString* arr_ReasonDict=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ReasonDict"]];
                 if(![arr_ReasonDict isEqual:@"<null>"])
                 {
                     NSDictionary* dic_ReasonDict=[dic_item objectForKey:@"ReasonDict"];
                     
                     model.ReasonDict=[NSString stringWithFormat:@"%@",[dic_ReasonDict objectForKey:@"DictName"]];
                 }
                 
                 //救援方法
                 NSString* arr_RemedyDict=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RemedyDict"]];
                 if(![arr_RemedyDict isEqual:@"<null>"])
                 {
                     NSDictionary* dic_RemedyDict=[dic_item objectForKey:@"RemedyDict"];
                     
                     model.RemedyDict=[NSString stringWithFormat:@"%@",[dic_RemedyDict objectForKey:@"DictName"]];
                 }

                 
                 
                 model.UseConfirmTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"UseConfirmTime"]];
                 model.RescueNumber=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescueNumber"]];
                 model.RescuePhone=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescuePhone"]];
                 model.Content=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"Content"]];
                 model.RescueCompleteTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescueCompleteTime"]];
                 model.MaintConfirmTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"MaintConfirmTime"]];
                 [self  OneBignNeedle:model];
                 
                 
             }
             else
             {
                 [self showAlter:@"获取数据失败！"];
             }
             
         }
         else
         {
             [self showAlter:@"获取数据失败！"];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"获取数据失败！"];
     }];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)showAlter:(NSString *)massage{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:massage
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
    [alert show];
    
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
@end
