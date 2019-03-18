//
//  elevatorRescueView.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/8.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "elevatorRescueView.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@implementation elevatorRescueView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    double newWidth=[UIScreen mainScreen].bounds.size.width/4;
    //self.view.frame=CGRectMake(0, 0, 320, 30) ;
    //dispatch_async(dispatch_get_main_queue(), ^{
        _v1.frame=CGRectMake(0, _v1.frame.origin.y, newWidth, _v1.frame.size.height) ;
        _v2.frame=CGRectMake(newWidth, _v2.frame.origin.y, newWidth, _v2.frame.size.height) ;
        _v3.frame=CGRectMake(newWidth*2, _v3.frame.origin.y, newWidth, _v3.frame.size.height) ;
        _v4.frame=CGRectMake(newWidth*3, _v4.frame.origin.y, newWidth, _v4.frame.size.height) ;
    
    [self addImg:@"dlxx_Tag_1" forView:_v1];
    [self addImg:@"dlxx_Tag_2" forView:_v2];
    [self addImg:@"dlxx_Tag_3" forView:_v3];
    [self addImg:@"dlxx_Tag_4" forView:_v4];
    [self addLine:_v2];
    [self addLine:_v3];
    [self addLine:_v4];
    
        _lable1.frame=CGRectMake(_lable1.frame.origin.x, _lable1.frame.origin.y, newWidth, _lable1.frame.size.height) ;
        _lable2.frame=CGRectMake(_lable2.frame.origin.x, _lable2.frame.origin.y, newWidth, _lable2.frame.size.height) ;
        _lable3.frame=CGRectMake(_lable3.frame.origin.x, _lable3.frame.origin.y, newWidth, _lable3.frame.size.height) ;
        _lable4.frame=CGRectMake(_lable4.frame.origin.x, _lable4.frame.origin.y, newWidth, _lable4.frame.size.height) ;
        _lable5.frame=CGRectMake(_lable5.frame.origin.x, _lable5.frame.origin.y, newWidth, _lable5.frame.size.height) ;
        _lable6.frame=CGRectMake(_lable6.frame.origin.x, _lable6.frame.origin.y, newWidth, _lable6.frame.size.height) ;
        
        _lable7.frame=CGRectMake(_lable7.frame.origin.x, _lable7.frame.origin.y, newWidth, _lable7.frame.size.height) ;
        _lable8.frame=CGRectMake(_lable8.frame.origin.x, _lable8.frame.origin.y, newWidth, _lable8.frame.size.height) ;
        _lable9.frame=CGRectMake(_lable9.frame.origin.x, _lable9.frame.origin.y, newWidth, _lable9.frame.size.height) ;
        _lable10.frame=CGRectMake(_lable10.frame.origin.x, _lable10.frame.origin.y, newWidth, _lable10.frame.size.height) ;
        _lable11.frame=CGRectMake(_lable11.frame.origin.x, _lable11.frame.origin.y, newWidth, _lable11.frame.size.height) ;
    //});

    UILabel *labLine1=[MyControl createLabelWithFrame:CGRectMake(0, self.view.frame.size.height-1, bounds_width.size.width, 1) Font:14 Text:@""];
    labLine1.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:labLine1];

}
-(void)addImg:(NSString *)imgName forView:(UIView *)view{
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 5)];
    imgView.image=[UIImage imageNamed:imgName];
    [view addSubview:imgView];
}
-(void)addLine:(UIView *)view{
    UILabel *imgView=[[UILabel alloc]initWithFrame:CGRectMake(0, 12, 1, 25)];
    imgView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view addSubview:imgView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
-(void)changeLableText:(NSString *) lab1 for2:(NSString *) lab2 for4:(NSString *) lab4 for6:(NSString *) lab6 for7:(NSString *) lab7
for9:(NSString *) lab9 for10:(NSString *) lab10{
    
    _lable1.text = lab1;
    _lable2.text = lab2;
    _lable4.text = lab4;
    _lable6.text = lab6;
    _lable7.text = lab7 ;
    _lable9.text = lab9;
    _lable10.text = lab10 ;
    
   
}


@end
