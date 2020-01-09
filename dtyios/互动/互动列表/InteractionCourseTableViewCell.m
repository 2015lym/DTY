//
//  CourseTableViewCell.m
//  AlumniChat
//
//  Created by SongQues on 16/6/15.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "InteractionCourseTableViewCell.h"
#import <CoreText/CoreText.h>
@implementation InteractionCourseTableViewCell

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
    lab_title.text=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"title"]];
    
    lab_isEnroll.text=[NSString stringWithFormat:@"%@人已评论",[dic_info objectForKey:@"comments"]];
    
    
    lab_nikeName.text=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"nikeName"]];
    lab_time.text=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"gmtCreate"]];
    
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, bounds_width.size.width,self.frame.size.height);
    
    backView.frame=CGRectMake(backView.frame.origin.x, backView.frame.origin.y, bounds_width.size.width,backView.frame.size.height);
    
    NSString *type=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"type"]];
 self.currHeight=90;
if([type isEqualToString:@"2"])
{
    backView.frame=CGRectMake(backView.frame.origin.x, backView.frame.origin.y, bounds_width.size.width,94);
    
     self.currHeight=100;
    image_Header.image=[UIImage imageNamed:@"placeholder.png"];
    [image_Header setupView:[UIImage imageNamed:@"placeholder.png"] delegate:nil];
    image_Header.hidden=false;
    
    NSString *str_url=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"picUrl"]];
    NSURL *imageurl=[NSURL URLWithString:str_url];
    image_Header.imageURL=imageurl;
   
}

  
    
   
    

    return YES;
}

- (void)setFrame:(CGRect)frame
{
    float width=bounds_width.size.width;
    
    frame.size.width = width;
    [super setFrame:frame];
    
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
