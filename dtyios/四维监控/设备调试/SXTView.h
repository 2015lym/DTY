//
//  SXTView.h
//  dtyios
//
//  Created by Lym on 2020/4/9.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SxtviewDelegate <NSObject>

- (void)sxtSearchDelegate;

- (void)sxtSubmitDelegate;

@end

@interface SXTView : UIView
@property (weak, nonatomic) IBOutlet UIButton *selectTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, weak) id<SxtviewDelegate> delegate;

@end
