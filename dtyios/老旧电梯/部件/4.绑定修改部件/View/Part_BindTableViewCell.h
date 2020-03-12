//
//  Part_BindTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/13.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BindPartModel.h"

@protocol Part_BindTableViewCellDelegate <NSObject>

- (void)updateText:(NSString *)Id andIndexPath:(NSIndexPath *)indexPath;

- (void)deleteAtIndex:(NSIndexPath *)indexPath;

- (void)getQrcodeAtIndex:(NSIndexPath *)indexPath;

@end


@interface Part_BindTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, weak) id<Part_BindTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UILabel *nfcLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) BindPartModel *model;

@property (nonatomic, assign) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
