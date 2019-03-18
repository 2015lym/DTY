//
//  Indication.h
//  YONChat
//
//  Created by xiaoanzi on 14-11-17.
//
//

#import <UIKit/UIKit.h>

@interface Indication : UIView
{
    
    UIActivityIndicatorView *arctivity;
    UIImageView *image_view;
    NSString * uuid_id;
}
@property (strong,nonatomic)UILabel *lab_label1;
@property (nonatomic) BOOL isStar;
-(void)startAnimating;
-(void)stopAnimating;
-(void)setText;
@end
