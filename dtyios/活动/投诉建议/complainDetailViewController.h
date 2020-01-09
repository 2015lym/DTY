//
//  complainDetailViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/12/14.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface complainDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *Type;
@property (weak, nonatomic) IBOutlet UITextField *Status;
@property (weak, nonatomic) IBOutlet UITextField *Title;
@property (weak, nonatomic) IBOutlet UITextView *Content;
@property (weak, nonatomic) IBOutlet UITextField *Penson;
@property (weak, nonatomic) IBOutlet UITextField *Phone;
@property (weak, nonatomic) IBOutlet UITextField *CreatePenson;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *tfNum;
@property (weak, nonatomic) NSMutableDictionary *dic_value;
@end
