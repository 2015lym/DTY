//
//  Task_InputTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/11.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task_RiskPartModel.h"
#import "EnvFormDelegate.h"

@interface Task_InputTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, weak) id<EnvFormDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@property (nonatomic, assign) BOOL isPreview;
@property (nonatomic, strong) NSMutableDictionary *model;
@property (nonatomic, assign) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
