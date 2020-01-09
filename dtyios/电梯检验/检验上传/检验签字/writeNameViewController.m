//
//  writeNameViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/7/18.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "writeNameViewController.h"
#import "warningElevatorModel.h"
#import "CommonUseClass.h"
#import "RequestWhere.h"
#import "MyControl.h"
#import "EventCurriculumEntity.h"
#import "DTWBDetailClass.h"
#import "DTWBStepClass.h"
#import "DTWBUserClass.h"
#import "BJTSignView.h"
#import "XXNet.h"
//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UIColorRGB(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1])
@interface writeNameViewController ()
{
    RequestWhere *_requestWhere;
    NSString *tabSelectIndex;
    NSString *code_lab;
    UILabel *label_2;
    
    NSString *Longitude ;
    NSString *Latitude ;
    
    NSDictionary *dicti;
    
    NSDictionary *dicWB;
}
@property(nonatomic,strong) BJTSignView *signView;

@end

@implementation writeNameViewController

@synthesize app;
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"检测签字";
    tabSelectIndex = @"3";
    _requestWhere=[[RequestWhere alloc]init];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
   
    [self LoadUI];
    
    _view_pop = [[UIView alloc]init];
    _view_pop.userInteractionEnabled=YES;
    _view_pop.frame=CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
    _view_pop.backgroundColor = [UIColor greenColor];
    _view_pop.hidden = YES;
    //    _view_pop .backgroundColor=[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:0];
    [self.view addSubview:_view_pop];
    
//    //    UITapGestureRecognizer
//    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
//    tapGesture.delegate=self;
//    [_view_pop addGestureRecognizer:tapGesture];
    
    _view_Content = [[UIView alloc]init];
    _view_Content.frame=CGRectMake(10, 20, SCREEN_WIDTH-20,SCREEN_HEIGHT/3);
    _view_Content.hidden = YES;
    [_view_pop addSubview:_view_Content];
    [self CloseAllClassIfication];
   
}
- (void)LoadUI {
    self.view.backgroundColor=[UIColor whiteColor];
    type=_TypeID;
    shi_labDetail = [MyControl createLabelWithFrame:CGRectMake(10, 0, bounds_width.size.width-10, 40) Font:14 Text:_TypeName];
    shi_labDetail.userInteractionEnabled=YES;
    shi_labDetail.textColor = [UIColor blackColor];
    shi_labDetail.backgroundColor = [UIColor whiteColor];
//    shi_labBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, shi_labDetail.frame.size.width, 40) imageName:nil bgImageName:nil title:nil SEL:@selector(labBtnClick:) target:self];
//    shi_labBtn.tag = 200;
//    [shi_labDetail addSubview:shi_labBtn];
    [self.view addSubview:shi_labDetail];
    shi_lab = [MyControl createLabelWithFrame:CGRectMake(0, 40, bounds_width.size.width, 1) Font:14 Text:@""];
    shi_lab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:shi_lab];
    
//    UIImageView *uiimg=[MyControl createImageViewWithFrame:CGRectMake(bounds_width.size.width-40, 10, 20, 20) imageName:@"ic_arrow_right.png"];
//    [self.view addSubview:uiimg];
    
    UIView *viewSign = [[UIView alloc]initWithFrame:CGRectMake(0,41 , SCREEN_WIDTH, 270)];//SCREEN_HEIGHT-220-64
    viewSign.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewSign];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 20)];
    label.text = @"请在此处签名:";
    label.font = [UIFont systemFontOfSize:14];
    [viewSign addSubview:label];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 5, 40, 20)];
    [button setImage:[UIImage imageNamed:@"clear.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ClearMethod:) forControlEvents:UIControlEventTouchUpInside];
    [viewSign addSubview:button];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(label.frame)+5, SCREEN_WIDTH, 200)];
    [viewSign addSubview:backView];
    backView.layer.masksToBounds = YES;
    backView.layer.borderColor = GrayColor(234).CGColor;
    backView.layer.borderWidth = 1;
    backView.backgroundColor = [UIColor whiteColor];
    self.signView = [[BJTSignView alloc] initWithFrame:backView.bounds];
    [backView addSubview:self.signView];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, viewSign.frame.size.height-40, SCREEN_WIDTH, 40)];
    [btn2 setBackgroundColor:RGBACOLOR(53, 115, 250, 1)];
    [btn2 setTitle:@"确认签字" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(SubmitData:) forControlEvents:UIControlEventTouchUpInside];
    [viewSign addSubview:btn2];
}
- (void)ClearMethod:(UIButton *)sender {
    [self.signView clearSignature];
}
//- (void)SureMethod:(UIButton *)sender {
//    UIImage *image  =  [self.signView getSignatureImage];//签字生成的图片
//    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
//
//    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
//    [dicHeader setValue:_lift_ID forKey:@"InspectId"];
//    [dicHeader setValue:type forKey:@"TypeId"];
//
//    [XXNet requestAFURL:dtjy_writeName parameters:dicHeader imageData:data succeed:^(NSDictionary *data) {
//        //        NSLog(@"%@",data);
//        if ([data[@"Success"]intValue]) {
//            NSString *str_imgurl = data[@"Data"];
//            [self SubmitData:str_imgurl];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//}

//UIImage图片转成Base64字符串
-(NSString *)ImageToBase64:(UIImage *)originImage
{
    
    NSData *data = UIImageJPEGRepresentation(originImage, 0.2f);
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedImageStr;
}
- (void)SubmitData:(UIButton *)sender {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    UIImage *image  =  [self.signView getSignatureImage];//签字生成的图片
    NSString * strImg= [self ImageToBase64:image];
    [dic setValue:strImg forKey:@"SignUrl"];
    [dic setValue:_lift_ID forKey:@"InspectId"];
    [dic setValue:type forKey:@"TypeId"];
    
    [XXNet post:dtjy_writeName parameters:[dic JSONString] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
        NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary* dic_result=[str_result objectFromJSONString];
        NSString *success=[dic_result objectForKey:@"Success"];
        if (success.intValue == 1) {
            [self performSelectorOnMainThread:@selector(SuccesseAddMethod:) withObject:nil waitUntilDone:NO];
            
        }
        else
        {
            [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:nil waitUntilDone:NO];
            return ;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonUseClass showAlter:@"服务器错误！"];
        NSLog(@"%@",error);
    }];
}

- (void)SuccesseAddMethod:(NSMutableArray*)arr {
    
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_qianrenOK" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [CommonUseClass showAlter:@"提交成功!"];
    [self.navigationController popViewControllerAnimated:true];
}
- (void)selectDataErr:(NSMutableArray*)arr {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [CommonUseClass showAlter:@"提交失败!"];
}

- (void)addAnnotation:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        //do something...:)
        NSLog(@"dddddddd");
    }
}

#pragma mark ClassIficationDelegate
-(void)CloseAllClassIfication
{
    [view_ification_02 removeFromSuperview];
    //    view_ification_02=nil;
    //    _view_pop.hidden=YES;
    _view_Content.hidden = YES;
}

-(void)ColesTypeView:(UIView *)typeView
{
    if(typeView ==view_ification_02)
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
    
}

-(void)Cell_OnClick:(id)Content typeView:(UIView *)typeView
{
    ClassIfication *currClass=(ClassIfication *)typeView;
    if(typeView ==view_ification_02)
    {
            shi_labDetail.text=[Content objectForKey:@"tagName"];
            shi_labDetail.tag=[[Content objectForKey:@"tagId"] intValue];
        type=[Content objectForKey:@"tagId"];
      
        
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
    _view_pop.hidden=true;
    
}
- (void)labBtnClick:(id)btn
{
    UIButton * currBtn=(UIButton *)btn;
    //    float currHeight=currBtn.frame.origin.y+currBtn.frame.size.height;
    //    NSLog(@"====+++++%f",currHeight);
    
    NSMutableArray *arr2=[[NSMutableArray alloc]init];
    NSMutableDictionary *dic1=[[NSMutableDictionary alloc]init];
    [dic1 setObject:@"1" forKey:@"tagId"];
    [dic1 setObject:@"制动器试验" forKey:@"tagName"];
    [arr2 addObject:dic1];
    NSMutableDictionary *dic2=[[NSMutableDictionary alloc]init];
    [dic2 setObject:@"2" forKey:@"tagId"];
    [dic2 setObject:@"限速器校验" forKey:@"tagName"];
    [arr2 addObject:dic2];
    NSMutableDictionary *dic3=[[NSMutableDictionary alloc]init];
    [dic3 setObject:@"3" forKey:@"tagId"];
    [dic3 setObject:@"平衡系数校验" forKey:@"tagName"];
    [arr2 addObject:dic3];
    
    NSLog(@"市");
    NSLog(@"arr2===%@",arr2);
    _view_pop.frame=CGRectMake(0, 41, bounds_width.size.width, bounds_width.size.height);
    _view_pop .backgroundColor=[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:0];
    _view_Content.frame=CGRectMake(0, 0, bounds_width.size.width-20, _view_Content.frame.size.height);
    
    CGRect rect=_view_Content.frame;
    rect.origin.x=0;
    rect.origin.y=0;
    if (view_ification_02!=nil) {//
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
        //[self CloseAllClassIfication];
        
        view_ification_02=[[ClassIfication alloc] initWithFrame:rect ArrList:[NSMutableArray arrayWithArray:arr2]];
        view_ification_02.table_view.tag=currBtn.tag;
        
        view_ification_02.delegate=self;
        rect.size.height=0;
        
        view_ification_02.frame=rect;
        [_view_Content addSubview:view_ification_02];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=_view_Content.frame;
            rect.origin.y=0;
            view_ification_02.frame=rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    _view_pop.hidden = NO;
    _view_Content.hidden = NO;
}
-(void)Actiondo:(UITapGestureRecognizer *)gesture
{
    NSLog(@"+++++++++++");
    
    _view_Content.hidden=YES;
    _view_pop.hidden=YES;
}
@end
