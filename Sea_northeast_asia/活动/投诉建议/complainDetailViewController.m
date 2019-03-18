//
//  complainDetailViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/12/14.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "complainDetailViewController.h"

@interface complainDetailViewController ()

@end

@implementation complainDetailViewController
-(void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title=@"投诉建议详情";
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.frame=CGRectMake(0, _scrollView.frame.origin.y,bounds_width.size.width , _scrollView.frame.size.height);
    // Do any additional setup after loading the view.
    NSDictionary *AdviceTypeDict=[_dic_value objectForKey:@"AdviceTypeDict"] ;
    if(AdviceTypeDict.count>0)
    {
        _Type.text=[AdviceTypeDict objectForKey:@"DictName"];
    }
    
    NSDictionary *AdviceStatusDict=[_dic_value objectForKey:@"AdviceStatusDict"] ;
    if(AdviceStatusDict.count>0)
    {
        _Status.text=[AdviceStatusDict objectForKey:@"DictName"];
    }

    _Title.text=[NSString stringWithFormat:@"%@",[_dic_value objectForKey:@"Title"]];
    
     _Content.text=[NSString stringWithFormat:@"%@",[_dic_value objectForKey:@"Remark"]];
    
     _Penson.text=[NSString stringWithFormat:@"%@",[_dic_value objectForKey:@"ContactName"]];
    
     _Phone.text=[NSString stringWithFormat:@"%@",[_dic_value objectForKey:@"ContactPhone"]];
    
    _tfNum.text=[NSString stringWithFormat:@"%@",[_dic_value objectForKey:@"LiftId"]];
    NSDictionary *CreateUser=[_dic_value objectForKey:@"CreateUser"] ;
    if(CreateUser.count>0)
    {
    _CreatePenson.text=[CreateUser objectForKey:@"UserName"];
    }
    
    if(!(_Phone.text ==nil))
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"telephone.png"]  forState: UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"telephone.png"]  forState: UIControlStateSelected];
        btn.frame=CGRectMake(bounds_width.size.width-40, 270, 27,27);
        btn.tag=[_Phone.text longLongValue];
        
        [btn addTarget:self action:@selector(addClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }

}
// MARK: - UIButton点击事件
-(void) addClickBtn:(UIButton *)btn {
    
    
    NSString *srt_url=[NSString stringWithFormat:@"tel://%ld", btn.tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:srt_url]];
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
