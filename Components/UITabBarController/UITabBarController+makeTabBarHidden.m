//
//  UITabBarController+makeTabBarHidden.m
//  HIChat
//
//  Created by Song Ques on 13-12-27.
//  Copyright (c) 2013年 Song Ques. All rights reserved.
//

#import "UITabBarController+makeTabBarHidden.h"

@implementation UITabBarController (makeTabBarHidden)

- (void)makeTabBarHidden:(BOOL)hide
{
    if ( [self.view.subviews count] < 2 )
    {
        return;
    }
    UIView *contentView;
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
    {
        contentView = [self.view.subviews objectAtIndex:1];
    }
    else
    {
        contentView = [self.view.subviews objectAtIndex:0];
    }
    if ( hide )
    {
        [contentView setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    else
    {
        contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.y,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height - self.tabBar.frame.size.height);
    }
    self.tabBar.hidden = hide;
    
}

@end
