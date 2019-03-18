//
//  showImage.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/26.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "showImage.h"
#import "EGOImageView.h"
@interface showImage ()

@end

@implementation showImage
-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查看详情";
    self.view.backgroundColor=[UIColor whiteColor];
    
    EGOImageView *imageview=[[EGOImageView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height)];
    
    if([_type isEqual:@"this"])
    {
        imageview.image=_image;
    }
    else
    {
    NSURL *url = [NSURL URLWithString:_url];
    imageview.imageURL=url;
    if(imageview.image==nil)
    {
        imageview.image=[UIImage imageNamed:@"no_photos.png"];
        imageview.frame=CGRectMake((bounds_width.size.width-178)/2, 60, 178, 128);
    }
    }
    [self.view addSubview:imageview];
    
    //添加手势
    UITapGestureRecognizer *Add_TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(View_AddTap:)];
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:Add_TapGesture];
}

- (void)View_AddTap:(id)dateTap
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
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
