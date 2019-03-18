//
//  GrayPageControl.m
//
//  Created by blue on 12-9-28.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood
//


#import "GrayPageControl.h"


@implementation GrayPageControl


- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if ( self ) {

        activeImage = [UIImage imageNamed:@"inactive_page_image"];
        inactiveImage = [UIImage imageNamed:@"active_page_image"];

        [self setCurrentPage:1];
    }
    return self;
}

- (id)initWithFrame:(CGRect)aFrame {
    
	if (self = [super initWithFrame:aFrame]) {

        activeImage = [UIImage imageNamed:@"inactive_page_image"];
        inactiveImage = [UIImage imageNamed:@"active_page_image"];

        [self setCurrentPage:1];
	}
	return self;
}


- (void)updateDots {

    for (int i = 0; i < [self.subviews count]; i++) {

        UIImageView* dot = [self.subviews objectAtIndex:i];
        //dot.contentMode=UIViewContentModeScaleAspectFit;

        if (i == self.currentPage) {
            
            if ( [dot isKindOfClass:UIImageView.class] ) {
                
                ((UIImageView *) dot).image = activeImage;
            }
            else {
                UIGraphicsBeginImageContext(CGSizeMake(activeImage.size.width+1, activeImage.size.height+1));
                [activeImage drawInRect:CGRectMake(0, 0, activeImage.size.width+1, activeImage.size.height+1)];
                activeImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();

                dot.backgroundColor = [UIColor colorWithPatternImage:activeImage];
            }
        }
        else {
            
            if ( [dot isKindOfClass:UIImageView.class] ) {
                
                ((UIImageView *) dot).image = inactiveImage;
            }
            else {
                UIGraphicsBeginImageContext(CGSizeMake(inactiveImage.size.width+1, inactiveImage.size.height+1));
                [inactiveImage drawInRect:CGRectMake(0, 0, inactiveImage.size.width+1, inactiveImage.size.height+1)];
                inactiveImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                dot.backgroundColor = [UIColor colorWithPatternImage:inactiveImage];
            }
        }
    }
}

-(void) setCurrentPage:(NSInteger)page {

    [super setCurrentPage:page];

    [self updateDots];
}


-(void)dealloc {

    activeImage=nil;
    inactiveImage=nil;
//    LOGPRINT();
}

@end
