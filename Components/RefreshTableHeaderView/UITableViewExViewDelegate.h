//
//  UITableViewExViewDelegate.h
//  HIChat
//
//  Created by Song Ques on 14-6-2.
//  Copyright (c) 2014年 Song Ques. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableItem.h"
//#import "UITableViewCellEx.h"
@protocol UITableViewExViewDelegate <NSObject>

@required
-(void)MoreRecord;
-(void)TableRowClick:(UITableItem*)value;
-(void)TableRowClickCell:(UITableItem*)value forcell:(UITableViewCell*) cell;
-(void)TableHeaderRowClick:(UITableItem*)value;
-(void)pullUpdateData;

@optional
-(void)tableForDelete:(UITableItem*)value;
-(void)MyTableHeaderRowClick:(UITableItem*)value;
-(void)deleageTableviewScrollEnabled:(BOOL)enbled;
@end