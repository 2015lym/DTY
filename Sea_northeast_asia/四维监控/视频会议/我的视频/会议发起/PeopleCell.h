//
//  PeopleCell.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/5/24.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UITableViewCellEx.h"
#import "EGOImageView.h"
@interface PeopleCell : UITableViewCellEx

{
    UIImageView *  _mSelectedIndicator; //show the selected mark
    BOOL           _mSelected;        //differ from property selected
}
@property (nonatomic, assign) BOOL mSelected;
- (void)changeMSelectedState;
@property (nonatomic,strong) AppDelegate *app;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UIButton *checkbox;
@property (weak, nonatomic) IBOutlet UIButton *checkCell;

@property (weak, nonatomic) IBOutlet UILabel *lblMobile;
@property (weak, nonatomic) IBOutlet UILabel *lblRoleName;

@end
