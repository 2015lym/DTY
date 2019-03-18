//
//  HomeViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/6/27.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "HomeViewController.h"
#import "LableTopViewController.h"
#import "LoginViewController.h"
#import "Util.h"
#import "PersonController.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kRestOfHeight (kHeight - 64 - 49 - 44)
@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    return;
    areachang.hidden=true;
    //1.得到地区
    str_CachePath_AreasAll = [NSString stringWithFormat:@"%@%@",[Util GetMyCachesPath],@"AreasAll"];
    NSMutableArray  *allCity=[NSMutableArray arrayWithContentsOfFile:str_CachePath_AreasAll];
    if(allCity==nil)
    {
    [self getCityCode];
    }
    
    scvcs=[NSMutableArray array];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *dic_oAuth=[NSUserDefaults standardUserDefaults];
    self.app.str_token=[dic_oAuth objectForKey:@
                        "str_token"];
    if (self.app.str_token!=nil) {
        NSString *username=[dic_oAuth objectForKey:@
                            "username"];
        NSString *nikename=[dic_oAuth objectForKey:@
                  "nikename"];;
        NSString *pwd=[dic_oAuth objectForKey:@
             "pwd"];;
        NSString *uhead=[dic_oAuth objectForKey:@
               "uhead"];
        [app.userInfo setUserInfo:username forNikename:nikename forpwd:pwd forhead:uhead];
    }
    [self setupLocationManager];
    /*缓存标签*/
     str_CachePath_TagsSelect = [NSString stringWithFormat:@"%@%@",[Util GetMyCachesPath],@"TagsSelect"];
    _lable_info=[NSMutableArray arrayWithContentsOfFile:str_CachePath_TagsSelect];
     str_CachePath_TagsAll = [NSString stringWithFormat:@"%@%@",[Util GetMyCachesPath],@"TagsAll"];
     allTags=[NSMutableArray arrayWithContentsOfFile:str_CachePath_TagsAll];
    /*^^^^缓存标签^^^^*/
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ProblemTopView" owner:self options:nil];
    prolemtopview=(ProblemTopView*)[nibs objectAtIndex:0];
    //适配
    CGRect rect=prolemtopview.frame;
    rect.origin.x=0;
    rect.origin.y=0;
    rect.size=topview.frame.size;
    [prolemtopview setFrame:rect];
    
    //_lable_info=[NSMutableArray arrayWithObjects:@"热点", @"新闻", @"文化", @"旅游", @"生活圈",@"体育",@"娱乐", nil];
    //prolemtopview.All_array=[NSMutableArray arrayWithArray:_lable_info];

    //[prolemtopview initview];
    prolemtopview.delegate=self;
    [topview addSubview:prolemtopview];
  
    
    //2.
    scrollView=[[UIScrollView alloc]init];
    CGRect rect1= scrollView.frame;
    rect1=CGRectMake(0, rect.size.height, kWidth, kRestOfHeight);
    
    [scrollView setFrame:rect1];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled=YES;
    scrollView.delegate=self;
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:scrollView];
    [self initLableView:@"Problem"];
    
    if(_lable_info.count>0)
    {
        prolemtopview.All_array=[NSMutableArray arrayWithArray:_lable_info];
        [prolemtopview initview];
        scrollView.contentSize=CGSizeMake((_lable_info.count+2)*self.view.frame.size.width, 0);
        [self getTagsEX];
    }
    else
    {
        [self getTags];
    }

    
    [self addscvc];
    
    areachang.layer.masksToBounds = YES; //没这句话它圆不起来
    areachang.layer.cornerRadius = 10; //设置图片圆角的尺度
    
     [self setupLocationManager];
}
-(void)viewWillAppear:(BOOL)animated
{
    return;
    /*
    if (imageView_title==nil) {
        imageView_title=[[UIImageView alloc] init];
        imageView_title.image=[UIImage imageNamed:@"navigation_title"];
        imageView_title.tag=10000;
        imageView_title.frame=CGRectMake(bounds_width.size.width/2-51,3, 102, 42);
    }
     */
    self.tabBarController.navigationItem.title=@"";
    [self.tabBarController.navigationController.navigationBar addSubview:imageView_title];
    
    if(currButton!=nil)
     [self Problemtop_Btn_OnClick_memo :currButton];
//    self.tabBarController.navigationItem.rightBarButtonItem=rightItem;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 标签视图delegate
-(void)Problemtop_Btn_New
{
    currButton =prolemtopview.btn_01;
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)Problemtop_Btn_Area
{
    areachang.hidden=false;
    prolemtopview.btn_02.titleLabel.text=areaName1;
    currButton =prolemtopview.btn_02;
    [scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
}

-(void)Problemtop_Btn_OnClick:(NSMutableDictionary *)dic_tags sender:(id)sender
{
    currButton =sender;
    
    [self Problemtop_Btn_OnClick_memo :currButton];
}

-(void)Problemtop_Btn_OnClick_memo: (id)sender
{
    UIButton *btn=sender;
    
    int i=(int)btn.tag;
    if (i>_lable_info.count) {
        return;
    }
    //ProblemListViewController *ProblemName=[arr_view objectAtIndex:i];
    //[ProblemName voiceStop];
    
    if(i==0)
    {
        [scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
    }
    else
    {
    if(![self haveSubView:i])
    {
        [self addscvcOther:i];
    }
    i=(i+1)*self.view.frame.size.width;
    [scrollView setContentOffset:CGPointMake(i, 0) animated:YES];
    }
}
-(void)btn_OnClick_add
{
    /*
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"token.php"
     parameters:@{}
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",error);
     }];
    */
    //8be7cadf695a5b85
    //bf4f4b6469b95521
    
    if (lableTopVC!=nil) {
        CGRect rect=lableTopVC.view.frame;
        rect.origin.y=0-rect.size.height;
        lableTopVC.view.frame=rect;
        [self.view addSubview:lableTopVC.view];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=lableTopVC.view.frame;
            rect.origin.y=0;
            lableTopVC.view.frame=rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        lableTopVC=[[LableTopViewController alloc] initWithNibName:@"LableTopViewController" bundle:nil];
        lableTopVC.delegate=self;
        lableTopVC.view.clipsToBounds=YES;
        lableTopVC.lable_info=_lable_info;
        //lableTopVC.All_lable_info=[NSMutableArray arrayWithObjects:@"热点", @"新闻", @"文化", @"旅游", @"生活圈",@"体育",@"娱乐",@"金典",@"人文",@"地理",@"特色", nil];
        lableTopVC.All_lable_info=[self getTagsByArray:allTags];
        CGRect rect=self.view.frame;
        rect.origin.y=0;
        rect.size.height=0;
        lableTopVC.view.frame=rect;
        [self.view addSubview:lableTopVC.view];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=lableTopVC.view.frame;
            rect.size.height=self.view.frame.size.height;
            lableTopVC.view.frame=rect;
        } completion:^(BOOL finished) {
            
        }];
    }

}
-(void)closeLableTopView:(BOOL)haveChange
{
//    [lableTopVC.view removeFromSuperview];
    prolemtopview.btn_add.selected=NO;
    
    
    if (lableTopVC!=nil) {
        CGRect rect=lableTopVC.view.frame;
        rect.origin.y=0;
        lableTopVC.view.frame=rect;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=lableTopVC.view.frame;
            rect.size.height=0;
            lableTopVC.view.frame=rect;
            
        } completion:^(BOOL finished) {
            [lableTopVC.view removeFromSuperview];
            lableTopVC.delegate=nil;
            lableTopVC=nil;
        }];
        
        if(!haveChange)
        {
            return;
        }
        
        
        for (UIView *view_ in scrollView.subviews) {
            if (view_.tag==-1) {
                
            }
            else if(view_.tag==0)
            {
                
            }
            else
             [view_ removeFromSuperview];
        }
        
        _lable_info=[NSMutableArray arrayWithArray:lableTopVC.lable_info];
        [_lable_info writeToFile:str_CachePath_TagsSelect atomically:YES];//缓存推荐标签
        prolemtopview.All_array=[NSMutableArray arrayWithArray:_lable_info];
        
        [prolemtopview initview];
        [self initLableView:@"Problem"];
        scrollView.contentSize=CGSizeMake((_lable_info.count+2)*self.view.frame.size.width, 0);
        [prolemtopview scrollView_Did_EndDecelerating:0];
    }

}


-(void)btn_OnClick:(NSMutableArray *)infolist Index:(NSInteger)_index
{
    [self closeLableTopView:true];
    if (_index ==9999) {
        [prolemtopview scrollView_Did_EndDecelerating:0];
    }
    else
    {
        _index=_index+2;
        [prolemtopview scrollView_Did_EndDecelerating:_index*bounds_width.size.width];
    }
}
-(void)refRefshView{
    [self closeLableTopView:lableTopVC.haveChange];
}

-(void)rightLoginEvent{
    [self loginMethod];
}

-(void)loginMethod{
    //1.check
    if(app.str_token.length==0)
    {
        [self showLogin] ;
    }
    else
    {
        [self showPerson] ;
    }

    
  }


-(void)leftPshuWebview:(NSString *)url
{
    LeftWebViewController *leftWebVC=[[LeftWebViewController alloc]init];
    leftWebVC.view.frame=bounds_width;
    [leftWebVC setUrl:url];
    
    UINavigationController *nav_leftWebVC=[[ UINavigationController alloc]initWithRootViewController:leftWebVC];
    [self presentViewController:nav_leftWebVC animated:YES completion:^{
        
    }];
}


#pragma mark 显示登录或个人中心窗口
// 弹出登录窗口
-(void)showLogin
{
    LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:[Util GetResolution:@"LoginViewController"] bundle:nil];
    //loginVC.onePerson=self;
    UINavigationController *nav_loginVC=[[ UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav_loginVC animated:YES completion:^{
        
    }];
}
// 弹出个人中心窗口
-(void)showPerson
{
    PersonController *loginVC1=[[PersonController alloc]initWithNibName:[Util GetResolution:@"PersonController"] bundle:nil];
    UINavigationController *nav_loginVC1=[[ UINavigationController alloc]initWithRootViewController:loginVC1];
    [self presentViewController:nav_loginVC1 animated:YES completion:^{
        
    }];
}

-(void)HomeShowPerson{
    [rightVC showPersonInfo];
}


-(void)addscvc
{
    scvc=[[SchoolCourseViewController alloc] init];
    scvc.tag=@"-1";
    scvc.area=@"";
    scvc.view.tag=-1;
    //scvc.dic_school_info=dic_school_info;
    scvc.delegate=self;
    CGRect rect= scvc.view.frame;
    //rect=CGRectMake(kWidth*2, 0, kWidth, kRestOfHeight);
    rect=CGRectMake(0, 0, kWidth, kRestOfHeight);
    [scvc.view setFrame:rect];
    //[firstCollection addSubview:scvc.view];
    [scrollView addSubview:scvc.view];
}

-(void)addscvc_area:(NSString *)areaId
{
    scvc_area=[[SchoolCourseViewController alloc] init];
    scvc_area.tag=@"0";
    scvc_area.area=areaId;
    scvc_area.view.tag=0;
    scvc_area.delegate=self;
    CGRect rect= scvc_area.view.frame;
    rect=CGRectMake(kWidth, 0, kWidth, kRestOfHeight);
    [scvc_area.view setFrame:rect];
    [scvc_area.view addSubview:areachang];
    [scrollView addSubview:scvc_area.view];
}

-(void)addscvcOther:(int)page
{
    currPage=page;
    
  
        SchoolCourseViewController *scvc1=[[SchoolCourseViewController alloc] init];
        NSString *currTagName=_lable_info[currPage-1];
        scvc1.tag=[self getTagcode:currTagName];
        scvc.area=@"";
        scvc1.view.tag=[scvc1.tag intValue];
        
        scvc1.delegate=self;
        CGRect rect= scvc1.view.frame;
        
        rect=CGRectMake((currPage+1)*kWidth, 0, kWidth, kRestOfHeight);
        [scvc1.view setFrame:rect];
        [scvcs addObject:scvc1];
        [scrollView addSubview:scvc1.view];
   
}





 


#pragma mark scrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    CGFloat i= scrollView.contentOffset.x;
    [prolemtopview scrollView_Did_EndDecelerating:i];
}
#pragma mark 加载标签视图
-(void)initLableView:(NSString *)str_ProblemName
{
    /*
    for (UIView *view_header_item in [scrollView subviews]) {
        [view_header_item removeFromSuperview];
    }
    [arr_view removeAllObjects];
    ProblemListViewController *ProblemName;
    ProblemName=[[ProblemListViewController alloc]initWithNibName:@"ProblemListViewController" bundle:nil];
    ProblemName.dic_tags=nil;
    ProblemName.delegate=self;
    CGRect rect=self.view.frame;
    rect.size=scrollview.frame.size;
    rect.origin.x=0;
    rect.origin.y=0;
    rect.size.height=rect.size.height;
    ProblemName.view.frame=rect;
    //    ProblemName.view.backgroundColor=[UIColor redColor];
    [scrollview addSubview:ProblemName.view];
    [arr_view addObject:ProblemName];
    [ProblemName viewWillAppear:YES];
    int i=1;
    for (NSMutableDictionary *str in prolemtopview.All_array ) {
        if (i<=15) {
            ProblemName=[[ProblemListViewController alloc]initWithNibName:@"ProblemListViewController" bundle:nil];
            CGRect rect=ProblemName.view.frame;
            rect.size=scrollview.frame.size;
            rect.origin.x=i*self.view.frame.size.width;
            ProblemName.view.frame=rect;
            ProblemName.dic_tags=[NSMutableDictionary dictionaryWithDictionary:str];
            ProblemName.delegate=self;
            [scrollview addSubview:ProblemName.view];
            [arr_view addObject:ProblemName];
            [ProblemName viewWillAppear:YES];
        }
        i++;
    }
    scrollview.contentSize=CGSizeMake(arr_view.count*self.view.frame.size.width, 0);
     */
}

//得到标签
-(void)getTags
{
    return;
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:@"1" forKey:@"pageNo"];
    [dic_args setObject:@"-1" forKey:@"tagId"];
    [dic_args setObject:@"513" forKey:@"cityCode"];
    
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"index.php/News/getNewsTags"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
        
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
          if (dic_result.count>0) {
              int state_value=[[dic_result objectForKey:@"state"] intValue];
              NSDictionary* dic_resultValue=[dic_result objectForKey:@"result"];
              if (state_value==0) {
                  
                  allTags=[NSMutableArray arrayWithArray:[dic_resultValue objectForKey:@"allTags"]];
                  tags=[NSMutableArray arrayWithArray:[dic_resultValue objectForKey:@"tags"]];
                  
                  NSMutableArray *currallTags=[self getTagsByArray :allTags];
                  [allTags writeToFile:str_CachePath_TagsAll atomically:YES];//缓存所有标签
                  NSMutableArray *currtags=[self getTagsByArray :tags];
                  [currtags writeToFile:str_CachePath_TagsSelect atomically:YES];//缓存推荐标签
                  _lable_info=currtags;
                  prolemtopview.All_array=[NSMutableArray arrayWithArray:_lable_info];
                  lableTopVC.All_lable_info=currallTags;
                  
                  [prolemtopview initview];
                  scrollView.contentSize=CGSizeMake((_lable_info.count+2)*self.view.frame.size.width, 0);
              }
              else
              {
                  [self showAlter:@"获取标签列表失败！"];
                  //[self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
              }

          }
         else
         {
             [self showAlter:@"获取标签列表失败！"];
             //[self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"获取标签列表失败！"];
         //[self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
     }];
    
}
-(void)getTagsEX
{
    return;
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:@"1" forKey:@"pageNo"];
    [dic_args setObject:@"-1" forKey:@"tagId"];
    [dic_args setObject:@"513" forKey:@"cityCode"];
    
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"index.php/News/getNewsTags"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"state"] intValue];
             NSDictionary* dic_resultValue=[dic_result objectForKey:@"result"];
             if (state_value==0) {
                 
                 allTags=[NSMutableArray arrayWithArray:[dic_resultValue objectForKey:@"allTags"]];
                
                 
                 NSMutableArray *currallTags=[self getTagsByArray :allTags];
                 [allTags writeToFile:str_CachePath_TagsAll atomically:YES];//缓存所有标签
                 prolemtopview.All_array=[NSMutableArray arrayWithArray:_lable_info];
                 lableTopVC.All_lable_info=currallTags;
                 
                 [prolemtopview initview];
                 scrollView.contentSize=CGSizeMake((_lable_info.count+2)*self.view.frame.size.width, 0);
             }
             else
             {
                 //[self showAlter:@"获取标签列表失败！"];
                 //[self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
             }
             
         }
         else
         {
             //[self showAlter:@"获取标签列表失败！"];
             //[self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //NSLog(@"error:%@",[error userInfo] );
         //[self showAlter:@"获取标签列表失败！"];
         //[self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
     }];
    
}

-(void)showAlter:(NSString *)massage{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:massage
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
    [alert show];

}

-(id)getTagsByArray:(NSMutableArray *)tags1{
    NSMutableArray *result=[[NSMutableArray alloc]init];
    
    for (NSMutableDictionary *dic_item in tags1     ) {
        
        [result addObject:[dic_item objectForKey:@"tagName"]];
    }
    return result;
}

-(NSString *)getTagcode:(NSString *)tagName {
    
    for (NSMutableDictionary *dic_item in allTags ) {
        if([tagName isEqualToString:[dic_item objectForKey:@"tagName"]])
        {
            return [dic_item objectForKey:@"tagId"];
        }
        
    }
    
    
    return @"";
}

-(BOOL)haveSubView:(NSInteger  )tagId{
    bool b=NO;
    NSString *currTagName=_lable_info[tagId-1];
    tagId =[[self getTagcode:currTagName] intValue];

    
    for (UIView *curr in scrollView.subviews)
    {
        NSInteger currTag=curr.tag;
        if(tagId ==currTag)
        {
            b=YES;
        }
    }
    return  b;
}


#pragma 弹出名细页面
-(void)SchoolCoursePush:(UIViewControllerEx *)vc
{
    //[self.tabBarController.navigationController pushViewController:vc animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
    //decisionHandler(WKNavigationActionPolicyCancel);
    /*
     //http://192.168.1.111:8103/newsDetail.html?newsId=19
    NSArray *arr_messgeInfo=[hostname componentsSeparatedByString:@"xinwen"];
    NSString *srt_url=[NSString stringWithFormat:@"%@%@",@"http://192.168.1.111:8103/",[arr_messgeInfo objectAtIndex:1]];
    InteractionTwoViewController *ctvc=[[InteractionTwoViewController alloc] init];
    ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height+64);
    [ctvc setUrl:srt_url];
    [self.navigationController pushViewController:ctvc animated:YES];
    decisionHandler(WKNavigationActionPolicyCancel);
    */
}

#pragma 切换城市
- (IBAction)areachangeClick:(id)sender
{
    SelectSchoolViewController *ctvc=[[SelectSchoolViewController alloc] init];
    ctvc.delegate=self;
    ctvc.currAreaId=DWareaId;
    ctvc.currAreaName=DWareaName;
    ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
    
    [self.navigationController pushViewController:ctvc animated:YES];
}
-(void)returnAreainfo:(NSString *)_areaId forAreaname :(NSString *)_areaName
{
    areaId1=_areaId;
    areaName1=_areaName;
    prolemtopview.btn_02.titleLabel.text=areaName1;
    [prolemtopview setBtn_02_title:areaName1];
    [self addscvc_area:areaId1];
}

#pragma 定位相关
- (void) setupLocationManager {
    
    NSDate *date_Now=[Util convertStringToDate:[Util nowDateToString:@"yyyy-MM-dd HH:mm:ss"] formatValue:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval time=[date_Now timeIntervalSinceDate:Date_Location];
    int minute=((int)time)%(3600*24)%3600/60;
    if (minute>5||super.thrift_Location==NO) {
        //        self.app.Date_Location=[Util convertStringToDate:[Util nowDateToString:@"yyyy-MM-dd HH:mm:ss"] formatValue:@"yyyy-MM-dd HH:mm:ss"];
        [locationManager stopUpdatingLocation];
        locationManager=nil;
        locationManager = [[CLLocationManager alloc] init];
        if ([CLLocationManager locationServicesEnabled]) {
            //NSLog( @"Starting CLLocationManager" );
            locationManager.delegate = self;
            locationManager.distanceFilter =10.f;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
            {
#ifdef __IPHONE_8_0
                [locationManager requestWhenInUseAuthorization];
                [locationManager requestAlwaysAuthorization];
#endif
            }
            [locationManager startUpdatingLocation];
            
        } else {
            NSLog( @"Cannot Starting CLLocationManager" );
            locationManager.delegate = self;
            locationManager.distanceFilter = 200;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [locationManager startUpdatingLocation];
        }
    }
    else
    {
        [self performSelector:@selector(BroadcastingLocation) withObject:nil afterDelay:0.1];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    if(kCLAuthorizationStatusNotDetermined==[CLLocationManager authorizationStatus])
       super. is_Location=NO;
    else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted)
        super.is_Location=NO;
    else if(kCLAuthorizationStatusDenied==[CLLocationManager authorizationStatus])
        super.is_Location=NO;
    else
    {
        super.is_Location=YES;
        super.thrift_Location=YES;
    }
    if (locations.count!=0) {
        locationManager=manager;
        CLLocation *newLocation=[locations objectAtIndex:locations.count-1];
        checkinLocation = newLocation;
        //        self.app.checkinLocation=checkinLocation;
        // 获取经纬度
        NSLog(@"纬度:%f",newLocation.coordinate.latitude);
        NSLog(@"经度:%f",newLocation.coordinate.longitude);
        //------------------位置反编码---5.0之后使用-----------------
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation
                       completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (error!=nil) {
                 [self addscvc_area:@"643"];
             }
             else
             {
                 for (CLPlacemark *place in placemarks)
                 {
                     NSLog(@"name,%@",place.name);                       // 位置名
                     NSLog(@"locality,%@",place.locality);               // 市
                     NSLog(@"country,%@",place.administrativeArea);
                     Provinces=[NSString stringWithFormat:@"%@",place.administrativeArea];
                     City=[NSString stringWithFormat:@"%@",place.locality];
                     
                     if(![City isEqualToString:@""])
                     {
                         City=[City stringByReplacingOccurrencesOfString:@"市" withString:@""];
                         str_CachePath_AreasAll = [NSString stringWithFormat:@"%@%@",[Util GetMyCachesPath],@"AreasAll"];
                         NSMutableArray  *allCity=[NSMutableArray arrayWithContentsOfFile:str_CachePath_AreasAll];
                         NSString *areaId=[self getAreaId:City forAreas:allCity];
                         if(![areaId isEqualToString:@""])
                         {
                             DWareaName=City;
                             DWareaId=areaId;
                             prolemtopview.btn_02.titleLabel.text=City;
                             [prolemtopview setBtn_02_title:City];
                             [self addscvc_area:areaId];
                         }
                         else
                         {
                             [self addscvc_area:@"643"];
                         }
                         
                     }
                 }
             }
          }];
        Date_Location=[Util convertStringToDate:[Util nowDateToString:@"yyyy-MM-dd HH:mm:ss"] formatValue:@"yyyy-MM-dd HH:mm:ss"];
        if(manager)
            [manager stopUpdatingLocation];
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    //NSLog(@"无法获得定位信息");
    super.is_Location=NO;
    [manager stopUpdatingLocation];
    [self addscvc_area:@"643"];
}


-(void)BroadcastingLocation
{
    
    if (locationManager==nil) {
        locationManager = [[CLLocationManager alloc] init];
        if ([CLLocationManager locationServicesEnabled]) {
            //NSLog( @"Starting CLLocationManager" );
            locationManager.delegate = self;
            locationManager.distanceFilter =10.f;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
            {
#ifdef __IPHONE_8_0
                [locationManager requestWhenInUseAuthorization];
                [locationManager requestAlwaysAuthorization];
#endif
            }
            [locationManager startUpdatingLocation];
            
        } else {
            NSLog( @"Cannot Starting CLLocationManager" );
            locationManager.delegate = self;
            locationManager.distanceFilter = 200;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [locationManager startUpdatingLocation];
        }
    }
    else
    {
        //       NSArray *arr=[[NSArray alloc]initWithObjects:self.app.checkinLocation, nil];
        //       [self locationManager:locationManager didUpdateLocations:arr];
    }
    
    
    
}

//得到城市列表
-(void)getCityCode
{
    return;
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"index.php/News/getCityInfo"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"state"] intValue];
             NSDictionary* dic_resultValue=[dic_result objectForKey:@"result"];
             if (state_value==0) {
                 
                NSMutableArray *allCity=[NSMutableArray arrayWithArray:[dic_resultValue objectForKey:@"cityInfo"]];
                 
                 
                 /*缓存标签*/
                 [allCity writeToFile:str_CachePath_AreasAll atomically:YES];//缓存所有标签
                 /*^^^^缓存标签^^^^*/                  
             }
             else
             {
                 [self showAlter:@"获取城市信息失败！"];
                 [self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
             }
             
         }
         else
         {
             [self showAlter:@"获取城市信息失败！"];
             [self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"获取城市信息失败！"];
         [self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
     }];
    
}

-(NSString *)getAreaId:(NSString *)areaName forAreas :(NSMutableArray *) allCity
{
    NSMutableArray *arr_data;
    NSString *areaid=@"643";
    for (NSMutableDictionary *dic_item in allCity) {
        arr_data=[NSMutableArray arrayWithArray:[dic_item objectForKey:@"cityList"]];
        
        for (NSMutableDictionary * curr_item in arr_data) {
            NSString *currName=[curr_item objectForKey:@"tagName"];
            if([areaName isEqualToString: currName])
            {
                areaid=[curr_item objectForKey:@"tagId"];
                return areaid;
            }
        }
    }
    
    return areaid;
}

@end
