//
//  Env_InputTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/11.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Env_FormModel.h"
#import "EnvFormDelegate.h"

@interface Env_InputTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, weak) id<EnvFormDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) EnvironmentAssessmentCategoryEntityList *model;


@property (nonatomic, assign) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
