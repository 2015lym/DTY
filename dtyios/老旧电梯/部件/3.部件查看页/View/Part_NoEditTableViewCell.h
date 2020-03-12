//
//  Part_NoEditTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/13.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Part_EditCellDelegate.h"

#import "Part_PreviewModel.h"

@interface Part_NoEditTableViewCell : UITableViewCell

@property (nonatomic, weak) id<Part_EditCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UIButton *reasonButton;
@property (weak, nonatomic) IBOutlet UIButton *outButton;

@property (nonatomic, strong) Part_PreviewModel *model;

@property (nonatomic, assign) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
