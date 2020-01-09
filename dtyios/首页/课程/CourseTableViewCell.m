//
//  CourseTableViewCell.m
//  AlumniChat
//
//  Created by SongQues on 16/6/15.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "CourseTableViewCell.h"
#import <CoreText/CoreText.h>
#import "Util.h"
@implementation CourseTableViewCell

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
    NSMutableDictionary *dic_info=[NSMutableDictionary dictionaryWithDictionary:aObject_entity];
    lab_title.text=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"newsTitle"]];
    lab_isEnroll.text=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"provenance"]];
    
    NSString *str_time=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"gmtModify"]];
    NSDate *stratDate=[Util convertStringToDate:str_time formatValue:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate=[NSDate date];
    lab_date.text=[Util day_hour_stringNew:stratDate endDate:endDate];
    
 
    
    
    //[image_Header setupView:[UIImage imageNamed:@"placeholder"] delegate:nil];
   [image_Header setupView:[UIImage imageNamed:@"placeholder.png"] delegate:nil];
    [image_Header1 setupView:[UIImage imageNamed:@"placeholder.png"] delegate:nil];
    [image_Header2 setupView:[UIImage imageNamed:@"placeholder.png"] delegate:nil];

     NSMutableArray *newsImageList=[NSMutableArray arrayWithArray:[dic_info objectForKey:@"newsImageList"]];
    
    if(newsImageList.count>0)
    {
    NSMutableDictionary *dic_image=newsImageList[0];
    NSString *str_url=[NSString stringWithFormat:@"%@",[dic_image objectForKey:@"address"]];
    NSURL *imageurl=[NSURL URLWithString:str_url];
    image_Header.imageURL=imageurl;
    }
    else
        image_Header.image=[UIImage imageNamed:@"placeholder.png"];
    
    float currwidth=(bounds_width.size.width-40)/3;
    if(newsImageList.count>1)
    {
        image_Header.frame=CGRectMake(10, image_Header.frame.origin.y+30, currwidth,image_Header.frame.size.height);
        
        NSMutableDictionary *dic_image=newsImageList[1];
        NSString *str_url=[NSString stringWithFormat:@"%@",[dic_image objectForKey:@"address"]];
        NSURL *imageurl=[NSURL URLWithString:str_url];
        [image_Header1 setupView:[UIImage imageNamed:@"placeholder.png"] delegate:nil];
        image_Header1.imageURL=imageurl;
        image_Header1.frame=CGRectMake(currwidth+20, image_Header1.frame.origin.y+30, currwidth,image_Header1.frame.size.height);
        
        [image_Header2 setupView:[UIImage imageNamed:@"placeholder.png"] delegate:nil];
        dic_image=newsImageList[2];
        str_url=[NSString stringWithFormat:@"%@",[dic_image objectForKey:@"address"]];
        imageurl=[NSURL URLWithString:str_url];
        image_Header2.imageURL=imageurl;
        image_Header2.frame=CGRectMake(currwidth+currwidth+30, image_Header2.frame.origin.y+30, currwidth,image_Header2.frame.size.height);
        
       

        self.currHeight=130;
        
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, bounds_width.size.width,self.frame.size.height+50);
        
        
        lab_title.frame=CGRectMake(10, 0, bounds_width.size.width,lab_title.frame.size.height);
        
         lab_isEnroll.frame=CGRectMake(10, 108, 130,21);
        
        //线
        lblLine.frame=CGRectMake(lblLine.frame.origin.x, 129, bounds_width.size.width-20,lblLine.frame.size.height);
        
    }
    else
    {
    
        //线
        lblLine.frame=CGRectMake(lblLine.frame.origin.x, lblLine.frame.origin.y, bounds_width.size.width-20,lblLine.frame.size.height);

    
    self.currHeight=80;
    lab_title.frame=CGRectMake(lab_title.frame.origin.x, lab_title.frame.origin.y, bounds_width.size.width-image_Header.frame.size.width-30,lab_title.frame.size.height);
     lab_isEnroll.frame=CGRectMake(lab_isEnroll.frame.origin.x, lab_isEnroll.frame.origin.y, 130,21);
    
        
    
    NSArray *titleArray=[self getSeparatedLinesFromLabel:lab_title];
    NSArray *EnrollArray=[self getSeparatedLinesFromLabel:lab_isEnroll];
    if(titleArray.count>=2)
    {
        lab_isEnroll.hidden=true;
    }
    else
    {
        lab_title.frame=CGRectMake(lab_title.frame.origin.x, lab_title.frame.origin.y-10, bounds_width.size.width-image_Header.frame.size.width-30,lab_title.frame.size.height);


    }
        
    }
    
    //lab_date
    CGSize titleSize = [lab_date.text sizeWithFont:lab_date.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    float x =rect_screen.size.width-10-titleSize.width-5;
    float mywidth= titleSize.width+5;
    lab_date.frame=CGRectMake(x, lab_isEnroll.frame.origin.y,mywidth, 21);

    return YES;
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

@end
