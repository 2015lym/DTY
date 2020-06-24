//
//  MaintenanceRefuseOrderViewController.m
//  dtyios
//
//  Created by Lym on 2020/6/12.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceRefuseOrderViewController.h"

@interface MaintenanceRefuseOrderViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MaintenanceRefuseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"拒绝工单";
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%@", textView.text);
}

@end
