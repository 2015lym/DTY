//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"


//[UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1]
//#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define TEXT_COLOR_ex	 [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f
//#define
@interface EGORefreshTableHeaderView (Private)

- (void)setState:(EGOPullRefreshState)aState;

@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		_imageAnimation.hidden=YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 14.0f, self.frame.size.width, 12.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:10.0f];
		label.textColor = TEXT_COLOR_ex;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
//		_statusLabel=label;
		[label release];
		
        UIImageView *image=[[UIImageView alloc] init];
        image.image=[UIImage imageNamed:@"refreshAnimation_1.png"];
//        image.backgroundColor=[UIColor redColor];
        [self addSubview:image];
        _imageAnimation=image;
        [_imageAnimation setHighlighted:YES];
        [image release];


		UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityView.frame = CGRectMake( frame.size.width/2-10, frame.size.height - 48.0f, 20.0f, 20.0f);
		[self addSubview:activityView];
		_activityView = activityView;
		
		
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}
-(void)setview:(CGFloat)base
{
//    CGFloat y=(base)/2;
    CGPoint center;
    
    center.y=piont_makr.y-base/2+23;
    center.x=piont_makr.x;
    _refreshView.center=center;
    CGFloat size=base/50;
    [UIView beginAnimations:@"imageViewBig" context:nil];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform.a = size ;
    transform.b = 0 ;
    transform.c = 0;
    transform.d = size;
    transform.tx = 0;
    transform.ty = 0;
    [_refreshView setTransform:transform];
//
    [UIView commitAnimations];
}

- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];

    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize
                                          options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                                       attributes:attributes
                                          context:nil].size;

    
    [paragraphStyle release];
    
    
    labelSize.height=ceil(labelSize.height);
    
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize;
    
}
#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		//[formatter setAMSymbol:@"AM"];
		//[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"HH:mm:ss"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"上次刷新: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = @"松开刷新";
//			[CATransaction begin];
//			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
//			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
//			[CATransaction commit];
            [_activityView startAnimating];
            [_imageAnimation setHidden:YES];
			break;
		case EGOOPullRefreshNormal:
            [_imageAnimation setHidden:NO];
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
//			_statusLabel.text = @"下拉刷新";
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			 [_imageAnimation setHidden:YES];
//			_statusLabel.text = @"正在刷新";
//            [self setview:50];
			[_activityView startAnimating];
//			[CATransaction begin];
//			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
//			_arrowImage.hidden = YES;
//			[CATransaction commit];
//            [self PlayAnimation];
			break;
        case EGOOPullrefreshDone:
            
//            _statusLabel.text = @"刷新完成";
            [_activityView stopAnimating];
//            [CATransaction begin];
//            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//            _arrowImage.hidden = YES;
//            [CATransaction commit];
            _imageAnimation.image=[UIImage imageNamed:@"refreshAnimation_01.png"];
            break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
            NSLog(@"xiala12");
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:EGOOPullRefreshPulling];
            NSLog(@"xiala");
		}
        int i=scrollView.contentOffset.y;
        if (i<0) {
            if (i>-65) {
                float height=abs(i);
                if (height<20) {
                    height=0.00;
                }
                else
                {
                    height=height-20;
                }
               float MaxY=self.frame.size.height -20-height;
                _imageAnimation.frame=CGRectMake(self.frame.size.width/2-14, MaxY, 24, 65);
//                float width=height*1.4423;
//                float MaxX=self.frame.size.width/2;

                [self imageadfad:height];
            }
            else
            {
                [self setview:50];
//                float height=50;
//                float width=height*1.4423;
//                float MaxX=self.frame.size.width/2;
//               [self imageadfad:height];
            }

        }
        
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
    else
    {
        int i=scrollView.contentOffset.y;
        if (i<0) {
            if (i>-55) {
                float height=abs(i);
                if (height-5<0) {
                    height=0.00;
                }
                else
                {
                    height=height-5;
                }
//                float width=height*1.4423;
//                float MaxX=self.frame.size.width/2;
//                [self imageadfad:height];
            }
        }
    }
}
- (void)imageViewControllerBigAnimation{
    
 
    
}
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	
    [UIView animateWithDuration:0.5 animations:^{
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    } completion:^(BOOL finished) {
        [self setState:EGOOPullRefreshNormal];
    }];
    [self setState:EGOOPullrefreshDone];

}

-(void)imageadfad:(int)xy
{
    
    NSString *str_image=@"refreshAnimation_";
    xy=xy/2;
    NSLog(@"%i",xy);
    int cont= xy;
    if (xy>23) {
        cont=23;
    }
    str_image=[NSString stringWithFormat:@"%@%i.png",str_image,cont];
    _imageAnimation.image=[UIImage imageNamed:str_image];
  
}
#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    _refreshView=nil;
    [super dealloc];
}
-(void)setimagehiend
{
    _imageAnimation.hidden=YES;
//    _refreshBG.hidden=YES;
    _lastUpdatedLabel.hidden=YES;
    _statusLabel.hidden=YES;
    _refreshView.hidden=YES;
}

@end
