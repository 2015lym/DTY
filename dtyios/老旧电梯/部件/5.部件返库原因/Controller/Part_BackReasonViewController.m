//
//  Part_BackReasonViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/19.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Part_BackReasonViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "UITextView+ZWLimitCounter.h"

@interface Part_BackReasonViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation Part_BackReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"部件返库原因";
    _textView.zw_placeHolder = @"请填写返库原因";
 
    if (_isPreview) {
        _titleLabel.text = @"返库原因";
        _textView.text = _model.ReturnReason;
        _textView.editable = NO;
    } else {
        _titleLabel.text = @"请填写返库原因";
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(submit)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
}

- (void)submit {
    if (_textView.text.length == 0) {
        [self showInfo:@"部件返库原因"];
        return;
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"Id"] = _model.Id;
        dic[@"ReturnReason"] = _textView.text;
        [self showProgress];
        [NetRequest OLD_POST:reformTask_saveReturnReason params:dic callback:^(OldElevatorBaseModel *baseModel) {
            if (baseModel.Success) {
                [self showSuccess:@"返库成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self showInfo:baseModel.Message];
            }
            [self hideProgress];
        } errorCallback:^(NSError *error) {
            [self hideProgress];
        }];
    }
}

@end
