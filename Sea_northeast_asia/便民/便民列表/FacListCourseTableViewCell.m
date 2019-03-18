//
//  CourseTableViewCell.m
//  AlumniChat
//
//  Created by SongQues on 16/6/15.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "FacListCourseTableViewCell.h"
#import <CoreText/CoreText.h>
@implementation FacListCourseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)configTableViewCell:(id)aObject_entity index_row:(int)aIndex_row count:(int)aCount_source;
{
    
    //线
    lblLine.frame=CGRectMake(bounds_width.size.width/2, 85, 1,22);
    image_phone.frame=CGRectMake(bounds_width.size.width/4-12, 86, 22,22);
    image_area.frame=CGRectMake(bounds_width.size.width/4*3-12, 85, 18,22);
    
    NSMutableDictionary *dic_info=[NSMutableDictionary dictionaryWithDictionary:aObject_entity];
    lab_title.text=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"facTitle"]];
    lab_isEnroll.text=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"dacAddress"]];
    longitude=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"longitude"]] ;
    latitude=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"latitude"]] ;
    
    float s=[[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"juli"]] floatValue]*1000;
    NSString * jl=@"";
    
    if(s < 500){
        jl = @"<500m";
    } else if (s < 1000) {
        jl = @"<1km";
    } else {
        s=s/1000;
        s = round(s*10)/10;
        NSString *sjl= [NSString stringWithFormat:@"%.1f",s];
        
        jl = [sjl stringByAppendingString:@"km"] ;
    }
    lab_km.text=jl;
    
    //[image_Header setupView:[UIImage imageNamed:@"placeholder"] delegate:nil];
    image_Header.image=[UIImage imageNamed:@"placeholder.png"];
    [image_Header setupView:[UIImage imageNamed:@"placeholder.png"] delegate:nil];
    [image_Header1 setupView:[UIImage imageNamed:@"placeholder.png"] delegate:nil];
   [image_Header2 setupView:[UIImage imageNamed:@"placeholder.png"] delegate:nil];

     NSMutableArray *newsImageList=[NSMutableArray arrayWithArray:[dic_info objectForKey:@"imgsArray"]];
    
    
    
    if(newsImageList.count>0)
    {
    NSMutableDictionary *dic_image=newsImageList[0];
    NSString *str_url=[NSString stringWithFormat:@"%@",[dic_image objectForKey:@"address_x"]];
    NSURL *imageurl=[NSURL URLWithString:str_url];
    image_Header.imageURL=imageurl;
    }
    
    float currwidth=(bounds_width.size.width-40)/3;
    if(newsImageList.count>1)
    {
        image_Header.frame=CGRectMake(10, image_Header.frame.origin.y+30, currwidth,image_Header.frame.size.height);
        
        NSMutableDictionary *dic_image=newsImageList[1];
        NSString *str_url=[NSString stringWithFormat:@"%@",[dic_image objectForKey:@"address_x"]];
        NSURL *imageurl=[NSURL URLWithString:str_url];
        image_Header1.imageURL=imageurl;
        image_Header1.frame=CGRectMake(currwidth+20, image_Header1.frame.origin.y+30, currwidth,image_Header1.frame.size.height);
        
        if(newsImageList.count>2)
        {
        dic_image=newsImageList[2];
        str_url=[NSString stringWithFormat:@"%@",[dic_image objectForKey:@"address_x"]];
        imageurl=[NSURL URLWithString:str_url];
        image_Header2.imageURL=imageurl;
        image_Header2.frame=CGRectMake(currwidth+currwidth+30, image_Header2.frame.origin.y+30, currwidth,image_Header2.frame.size.height);
        }
        else
        {
            image_Header2.hidden=true;
        }
        
       

        self.currHeight=160;
        
        lblLine.frame=CGRectMake(bounds_width.size.width/2, 130, 1,22);
        image_phone.frame=CGRectMake(bounds_width.size.width/4-12, 132, 22,22);
        image_area.frame=CGRectMake(bounds_width.size.width/4*3-12, 130, 18,22);
        
        
        
        lab_title.frame=CGRectMake(10, 0, bounds_width.size.width-50,lab_title.frame.size.height);
        lab_isEnroll.frame=CGRectMake(10, 105, bounds_width.size.width,lab_isEnroll.frame.size.height);
        
    }
    else
    {
    
       

    
    self.currHeight=116;
    lab_title.frame=CGRectMake(lab_title.frame.origin.x, lab_title.frame.origin.y, bounds_width.size.width-image_Header.frame.size.width-30-35,lab_title.frame.size.height);
     lab_isEnroll.frame=CGRectMake(lab_isEnroll.frame.origin.x, lab_isEnroll.frame.origin.y, bounds_width.size.width-image_Header.frame.size.width-30,lab_isEnroll.frame.size.height);
    
        
    
    NSArray *titleArray=[self getSeparatedLinesFromLabel:lab_title];
    NSArray *EnrollArray=[self getSeparatedLinesFromLabel:lab_isEnroll];
    if(titleArray.count>=2)
    {
        lab_isEnroll.hidden=true;
    }
    else
    {
        lab_title.frame=CGRectMake(lab_title.frame.origin.x, lab_title.frame.origin.y-6, bounds_width.size.width-image_Header.frame.size.width-30-50,lab_title.frame.size.height);

        if(EnrollArray.count>=2)
           {
        lab_isEnroll.frame=CGRectMake(lab_isEnroll.frame.origin.x, lab_isEnroll.frame.origin.y-14, bounds_width.size.width-image_Header.frame.size.width-30,36);
           }
    }
        
    }
    
     view.frame=CGRectMake(0, 5, bounds_width.size.width,self.currHeight-5);
   
    phoneNumber =[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"facTel"]];

    
   
    
    //area
    UIButton *btnArea =[[UIButton alloc]init];
    // 设置事件
    [btnArea addTarget:self action:@selector(btnPressedArea:) forControlEvents:UIControlEventTouchUpInside];
    btnArea .frame=CGRectMake(image_area.frame.origin.x-20, image_area.frame.origin.y-10, image_area.frame.size.width+40, image_area.frame.size.height+20) ;
    //btnArea.backgroundColor=[UIColor blueColor];
    [view addSubview:btnArea];
    
    return YES;
}

-(IBAction)btnPressed:(id)sender
{
//    UIButton *myBtn = (UIButton *)sender;
    if([phoneNumber isEqualToString:@""])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil  otherButtonTitles:[NSString stringWithFormat:@"暂无电话"],nil];
        actionSheet.tag=1001;
        [actionSheet showInView:self];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil  otherButtonTitles:[NSString stringWithFormat:@"呼叫电话:%@",phoneNumber],nil];
        actionSheet.tag=1001;
        [actionSheet showInView:self];
    }

    
}

-(void)btnPressedArea:(id)sender
{
//    UIButton *myBtn = (UIButton *)sender;
    //[_delegate baiduMapPush:longitude for:latitude];
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:longitude,@"textOne",latitude,@"textTwo", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1001) {
        switch (buttonIndex) {
            case 0:
            {
                NSString *srt_tel=[NSString stringWithFormat:@"tel://%@",phoneNumber];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:srt_tel]];
            }
                break;
            default:
                break;
        }
    }
}


- (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}
- (void)setFrame:(CGRect)frame
{
    float width=bounds_width.size.width;
    
    frame.size.width = width;
    [super setFrame:frame];
    
}
- (IBAction)chickArea:(id)sender
{
    NSLog(@
          "");
}
@end
