//
//  ConvenienceViewIOSController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/8/11.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "ConvenienceViewIOSController.h"
#import "ConvenienceDetailsViewController.h"
@class CustomCollectionViewLayout;
@interface ConvenienceViewIOSController ()

@end

@implementation ConvenienceViewIOSController
static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";



- (void)viewDidLoad {
    [super viewDidLoad];
    return;
    [self getTags];
    [self getCityCode];
  
    str_CachePath_FacTypeAll = [NSString stringWithFormat:@"%@%@",[Util GetMyCachesPath],@"FacTypeAll"];
    _allTypes=[NSMutableArray arrayWithContentsOfFile:str_CachePath_FacTypeAll];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self.tabBarController.navigationController.navigationBar viewWithTag:10000] removeFromSuperview];
    self.tabBarController.navigationItem.title=@"便民查询";
    
}

//得到便民类型
-(void)getTags
{
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:@"1" forKey:@"pageNo"];    
    
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"index.php/Facilitate/getFacTypesForApp"
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
                 
                 
                 _allTypes=[NSMutableArray arrayWithArray:[dic_resultValue objectForKey:@"types"]];
                 [self addViewAll];
                 
                 //缓存所有便民类型
                 //NSMutableArray *currallTags=[self getTagsByArray :allTags];
                 [_allTypes writeToFile:str_CachePath_FacTypeAll atomically:YES];//
                 
             }
             else
             {
                 [self showAlter:@"获取便民类型列表失败！"];
                 [self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
             }
            
         }
         else
         {
             [self showAlter:@"获取便民类型列表失败！"];
             [self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"获取便民类型列表失败！"];
         [self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
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

- (void)addViewAll
{
    double curry=10;
    double currx=10;
    double currWidth=(bounds_width. size.width-40)/3;
    double currHeight=95;
    int i =0;
    int row=0;
    for (NSMutableDictionary *dic_item in _allTypes )
    {
        if(i%3==0)
        {
            currx=10;
        }
        else if (i%3==1)
        {
            currx=20+currWidth;
        }
        else if (i%3==2)
        {
            currx=30+currWidth*2;
        }
        
        
         NSString * tagId=[dic_item objectForKey:@"tagId"];
        NSString *tagName=[dic_item objectForKey:@"tagName"];
        NSString *image=[dic_item objectForKey:@"image"];
        
        
        [self addView:CGRectMake(currx,curry,currWidth,currHeight) forImage:image forLabel:tagName forTag:tagId];
        i=i+1;
        if(i%3==0)
        {row=row+1;
        curry=curry+currHeight+10;
        }
    }
}

- (void)addView:(CGRect )rect forImage: (NSString *)strImage forLabel :(NSString *)strLabel forTag:( NSString *)strTag
{
    UIView *cell=[[UIView alloc]initWithFrame:rect];
    cell.backgroundColor=[UIColor whiteColor];
    //cell.backgroundColor=[UIColor redColor];
    
    //image
    float left=(rect.size.width-(rect.size.height-52))/2;
    EGOImageView *image=[[EGOImageView alloc]initWithFrame:CGRectMake(left
                        ,14,rect.size.height-52,rect.size.height-52)];
    [image setupView:[UIImage imageNamed:@"placeholder.png"] delegate:nil];
    
    strImage = [strImage stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSURL *imageurl=[NSURL URLWithString:strImage];
    image.imageURL=imageurl;
    //image.contentMode =  UIViewContentModeScaleAspectFit;
    //image.backgroundColor=[UIColor redColor];
    [cell addSubview:image];
   

    
    //label
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, rect.size.height-30, rect.size.width, 20)];
    label.text=strLabel;
    [cell addSubview:label];
    label.textColor=[UIColor grayColor];
    label.font=[UIFont systemFontOfSize: 12.0];
    label.textAlignment= NSTextAlignmentCenter;
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    button.tag= [strTag intValue];;
    [button addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:button];
    
    [self.view.subviews[0] addSubview:cell];
    CGSize size=CGSizeMake(0, CGRectGetMaxY(cell.frame)+10);
    _scrollView.contentSize=size;
}

-(void)btnPressed:(id)sender
{
    UIButton *myBtn = (UIButton *)sender;
    ConvenienceDetailsViewController * cdvc=[[ConvenienceDetailsViewController alloc] initWithNibName:[Util GetResolution:@"ConvenienceDetailsViewController"] bundle:nil];
    [cdvc set_allCity:_allCity];
    int currtag=(int)myBtn.tag;
    [cdvc setSelectType:currtag];
    NSMutableDictionary *selectTag =[self getTagName:[NSString stringWithFormat:@"%d",currtag]];
    [cdvc setCurrTag:selectTag];
    
    
    [self.tabBarController.navigationController pushViewController:cdvc animated:YES];
}

-(NSMutableDictionary *)getTagName:(NSString *)tagId {
    
    for (NSMutableDictionary *dic_item in _allTypes ) {
        if([tagId isEqualToString:[dic_item objectForKey:@"tagId"]])
        {
            //return [dic_item objectForKey:@"tagName"];
            return dic_item;
        }
        
    }
    
    return nil;
}

 - (IBAction)down:(UIButton *)sender {
    [UIView animateWithDuration:1.0 animations:^{
        //三个步骤
          CGPoint offset = _scrollView.contentOffset;
         offset.y += 150;
         _scrollView.contentOffset = offset;

         //_scrollView.contentOffset = CGPointMake(0, 0);
     }];
 }
//得到便民类型
-(void)getCityCode
{

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
                 
                  _allCity=[NSMutableArray arrayWithArray:[dic_resultValue objectForKey:@"cityInfo"]];
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
@end
