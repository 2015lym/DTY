//
//  Examine_ContentTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/27.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Examine_ContentTableViewCellDelegate <NSObject>

- (void)changeId:(NSString *)examineCategoryId andResult:(NSString *)examineResult;

@end


@interface Examine_ContentTableViewCell : UITableViewCell

@property (nonatomic, weak) id<Examine_ContentTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *midButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, copy) NSString *examineCategoryId;
@property (nonatomic, copy) NSString *examineResult;

@property (nonatomic, assign) BOOL isPreview;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
