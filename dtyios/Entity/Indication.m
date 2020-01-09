//
//  Indication.m
//  YONChat
//
//  Created by xiaoanzi on 14-11-17.
//
//

#import "Indication.h"

@implementation Indication
@synthesize lab_label1;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lab_label1=[[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-21, self.frame.size.width, 21)];
        lab_label1.textColor=[UIColor whiteColor];
        lab_label1.textAlignment=NSTextAlignmentCenter;
        lab_label1.font=[UIFont systemFontOfSize:14.0f];
        
        image_view=[[UIImageView alloc] init];
        image_view.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        image_view.backgroundColor=[UIColor lightGrayColor];
        image_view.alpha=0.7;
        
        arctivity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        arctivity.frame=CGRectMake((self.frame.size.width-20)*0.5, (self.frame.size.height-20)*0.5, 20, 20);
        
        self.backgroundColor=[UIColor clearColor];
        [self addSubview:image_view];
        [self addSubview:lab_label1];
        [self addSubview:arctivity];
        
    }
    return self;
}
-(void)startAnimating
{
    [arctivity startAnimating];
}
-(void)stopAnimating
{
//    [self removeFromSuperview];
    [arctivity stopAnimating];
}
-(void)setText
{
    for (int i=0;i<100;i++) {
        lab_label1.text=[NSString
                         stringWithFormat:@"%i",i];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
