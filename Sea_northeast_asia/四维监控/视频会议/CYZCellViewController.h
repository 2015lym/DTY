//
//  CYZCellViewController.h
//  Sea_northeast_asia
//
//  Created by 王永超 on 2017/3/7.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "UITableViewCellEx.h"
#import "EGOImageView.h"
@interface CYZCellViewController : UITableViewCellEx
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

@end
