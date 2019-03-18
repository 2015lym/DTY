//
//  complainAdviceCell.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/12/14.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "complainAdviceCell.h"
#import <CoreText/CoreText.h>
#import "Util.h"
#import "JSONKit.h"
@implementation complainAdviceCell

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
    //title
    lab_title.text=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"Title"]];
   
    //time
    NSString *str_time=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"CreateTime"]];
   NSString *stratDate = [str_time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSArray *s = [stratDate componentsSeparatedByString:@"."];
    stratDate = [s objectAtIndex:0];
    lab_date.text=stratDate ;
    
    //state
    NSString *type;
    NSDictionary *AdviceTypeDict=[dic_info objectForKey:@"AdviceTypeDict"] ;
    if(AdviceTypeDict.count>0)
    {
        type=[AdviceTypeDict objectForKey:@"DictName"];
        _lbl_type.text=type;
    }
    NSString *state;
    NSDictionary *AdviceStatusDict=[dic_info objectForKey:@"AdviceStatusDict"] ;
    if(AdviceStatusDict.count>0)
    {
        //state=[state stringByAppendingString:@":"];
        state=[AdviceStatusDict objectForKey:@"DictName"];
    }
    lab_isEnroll.text=state;
    lab_isEnroll.hidden=YES;
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(bounds_width.size.width-48, 5, 43, 43)];
    [self .contentView addSubview:img];
    if([state isEqual:@"待跟进"])
    {img.image=[UIImage imageNamed:@"complaint_wait"];}
    else
    {img.image=[UIImage imageNamed:@"complaint_complete"];}
    

    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, bounds_width.size.width,self.frame.size.height+50);
    self.currHeight=123;

        //线
    lblLine.frame=CGRectMake(lblLine.frame.origin.x+5, lblLine.frame.origin.y, bounds_width.size.width-30,lblLine.frame.size.height);
    lab_title.frame=CGRectMake(lab_title.frame.origin.x, lab_title.frame.origin.y, bounds_width.size.width-image_Header.frame.size.width-30,lab_title.frame.size.height);
    lab_isEnroll.frame=CGRectMake(bounds_width.size.width-71, lab_isEnroll.frame.origin.y, 71,21);
    
    //lab_date
    lab_date.frame=CGRectMake(bounds_width.size.width-130, lab_date.frame.origin.y,130, 21);
    _lbl_back.frame=CGRectMake(_lbl_back.frame.origin.x, _lbl_back.frame.origin.y,bounds_width.size.width-10, _lbl_back.frame.size.height);
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
