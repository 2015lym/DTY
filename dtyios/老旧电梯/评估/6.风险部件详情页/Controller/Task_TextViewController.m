//
//  Task_TextViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/4/9.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_TextViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "Task_SelectTextViewController.h"

@interface Task_TextViewController ()<Task_SelectTextViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation Task_TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textView.zw_placeHolder = [NSString stringWithFormat:@"请输入%@", self.navigationItem.title];
    if (_previewString && _previewString.length > 0) {
        _textView.text = _previewString;
    }
    if (_isPreview) {
        _textView.editable = NO;
        _selectButton.hidden = YES;
    } else {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(save)];
        
        UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"清空"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(clear)];
        self.navigationItem.rightBarButtonItems = @[rightButton, clearButton];
    }
}

- (void)save {
    if (_textView.text.length == 0) {
        [self showInfo:[NSString stringWithFormat:@"请输入%@", self.navigationItem.title]];
        return;
    } else {
        if ([self.delegate respondsToSelector:@selector(saveText:andTitle:andIndexPath:)]) {
            [self.delegate saveText:_textView.text andTitle:self.navigationItem.title andIndexPath:_indexPath];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)clear {
    [self showAlertController:@"确定删除该项内容吗？" callBack:^{
        self.textView.text = @"";
        if ([self.delegate respondsToSelector:@selector(saveText:andTitle:andIndexPath:)]) {
            [self.delegate saveText:self.textView.text andTitle:self.navigationItem.title andIndexPath:self.indexPath];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)selectTemplate:(id)sender {
    Task_SelectTextViewController *vc = [Task_SelectTextViewController new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectText:(NSArray *)array {
    for (NSString *text in array) {
        if (!_textView.text && _textView.text.length == 0) {
            _textView.text = text;
        } else {
            _textView.text = [_textView.text stringByAppendingFormat:@"\n%@", text];
        }
    }
}
@end
