//
//  DTWBDetailCell.m
//  Sea_northeast_asia
//
//  Created by wyc on 2017/5/10.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "DTWBDetailCell.h"
#import "warningElevatorModel.h"
#import "DTWBDetailClass.h"
#import "CommonUseClass.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation DTWBDetailCell
@synthesize app;
- (BOOL)configTableViewCell:(id)aObject_entity index_row:(int)aIndex_row count:(int)aCount_source;
{
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
  
    //1.all set
    self.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.currHeight=244;
    self.selectionStyle= UITableViewCellSelectionStyleNone;
    
    //2.data
    DTWBDetailClass *warnmodel=(DTWBDetailClass *)aObject_entity;
    
    self.lab_Detail1.text = [NSString stringWithFormat:@"%@",warnmodel.Step.StepName];
    //self.lab_Detail1.numberOfLines = 2;
    
    NSString *IsPassedStr = [NSString stringWithFormat:@"%@",warnmodel.IsPassed];
    
    if ([IsPassedStr isEqualToString:@"1"]) {
        self.lab_Detail2.text = @"合格";
        //self.lab_Detail2.textColor = [UIColor greenColor];
    }else{
        self.lab_Detail2.text = @"不合格";
        //self.lab_Detail2.textColor = [UIColor greenColor];
    }
    
    self.lab_Detail3.text = [CommonUseClass FormatString:warnmodel.Remark];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:@"userName"];
    
    self.lab_Detail4.text = [NSString stringWithFormat:@"%@",userName];
    
    NSString *d4 = [NSString stringWithFormat:@"%@",warnmodel.CheckDate];
    NSArray *d5 =  [d4  componentsSeparatedByString:@"T"];
    if(![[d5 objectAtIndex:0] isEqual:@"<null>"]&&![[d5 objectAtIndex:0] isEqual:@""])
        _lab_Detail5.text=[d5 objectAtIndex:0];
    else
        _lab_Detail5.text=@"";
    if(![[d5 objectAtIndex:1] isEqual:@"<null>"]&&![[d5 objectAtIndex:1] isEqual:@""])
        _lab_time.text=[d5 objectAtIndex:1];
    else
        _lab_time.text=@"";
    
    
    _lab_back2.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _lab_back2.layer.borderWidth=1.0f;
    _lab_back2.layer.masksToBounds = YES;
    _lab_back2.layer.cornerRadius = 4;
    _lab_line.backgroundColor= [UIColor lightGrayColor];
 
    //2
    float width=(bounds_width.size.width-20)/3;
    _view_Image1.frame=CGRectMake(10+(width-23-65-5)/2,  _view_Image1.frame.origin.y,  _view_Image1.frame.size.width,  _view_Image1.frame.size.height);
    _lab_Title2.frame=CGRectMake(10+(width-23-65-5)/2+23+5,  _lab_Title2.frame.origin.y,  _lab_Title2.frame.size.width,  _lab_Title2.frame.size.height);
    _lab_Detail2.frame=CGRectMake(10,  _lab_Detail2.frame.origin.y,  width,  _lab_Detail2.frame.size.height);
    
    _view_Image2.frame=CGRectMake(10+(width-23-65-5)/2+width,  _view_Image2.frame.origin.y,  _view_Image2.frame.size.width,  _view_Image2.frame.size.height);
    _lab_Title4.frame=CGRectMake(10+(width-23-65-5)/2+23+5+width,  _lab_Title4.frame.origin.y,  _lab_Title4.frame.size.width,  _lab_Title4.frame.size.height);
    _lab_Detail4.frame=CGRectMake(10+width,  _lab_Detail4.frame.origin.y,  width,  _lab_Detail4.frame.size.height);

    
    _view_Image3.frame=CGRectMake(10+(width-23-65-5)/2+width*2,  _view_Image3.frame.origin.y,  _view_Image3.frame.size.width,  _view_Image3.frame.size.height);
    _lab_Title5.frame=CGRectMake(10+(width-23-65-5)/2+23+5+width*2,  _lab_Title5.frame.origin.y,  _lab_Title5.frame.size.width,  _lab_Title5.frame.size.height);
     _lab_Detail5.frame=CGRectMake(10+width*2,  _lab_Detail5.frame.origin.y,  width,  _lab_Detail5.frame.size.height);
    _lab_time.frame=CGRectMake(10+width*2,  _lab_time.frame.origin.y,  width,  _lab_time.frame.size.height);
    
    
    //UIView *view ;
    NSString *photoStr = [NSString stringWithFormat:@"%@",warnmodel.PhotoUrl];
    
    if ([photoStr isEqualToString:@""]) {
//        UIImage *image = [UIImage imageNamed:@"no_photos.png"];
//        [_view_Image setImage:image];
        
    }else{
        NSMutableString *mString = [NSMutableString stringWithString:photoStr];
        [mString deleteCharactersInRange:NSMakeRange(0, 1)];
        NSLog(@"%@",mString);
        
        
        //self.currHeight=300;
        //_lab_Title6.hidden = YES;
        //view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 280)];
        //self.view_Image.frame = CGRectMake(SCREEN_WIDTH/2-60, 170, 80, 100);
        
        NSString *http=[Ksdby_api_Img stringByAppendingString:mString];
        NSURL *url = [NSURL URLWithString:http];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        [_view_Image setImage:image];
        
    }
//    view.layer.masksToBounds=YES;
//    view.layer.cornerRadius=4.0;
//    view.backgroundColor = [UIColor whiteColor];
//    [self addSubview:view];
    
    
//    [view addSubview:_lab_Title1];
//    [view addSubview:_lab_Title2];
//    [view addSubview:_lab_Title3];
//    [view addSubview:_lab_Title4];
//    [view addSubview:_lab_Title5];
//    //[view addSubview:_lab_Title6];
//    [view addSubview:_lab_Detail1];
//    [view addSubview:_lab_Detail2];
//    [view addSubview:_lab_Detail3];
//    [view addSubview:_lab_Detail4];
//    [view addSubview:_lab_Detail5];
//    [view addSubview:_view_Image];
    
    return YES;
    
}

@end
