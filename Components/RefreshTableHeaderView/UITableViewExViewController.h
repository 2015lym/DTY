//
//  UITableViewExViewController.h
//  HIChat
//
//  Created by Song Ques on 14-6-2.
//  Copyright (c) 2014年 Song Ques. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "UITableItem.h"
#import "UITableViewExViewDelegate.h"
#import "UITableViewCellEx.h"
#import "baiduMap.h"
@interface UITableViewExViewController : UITableViewController<EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
}
@property (nonatomic,strong)EGORefreshTableHeaderView *_refreshHeaderView;
@property (nonatomic) int PageIndex;
@property (nonatomic) int PageCount;
@property (nonatomic) int currHeight;
@property (nonatomic) BOOL separatorStyFalg;
@property (nonatomic,weak) id<UITableViewExViewDelegate> delegateCustom;
@property (nonatomic,weak) id<baiduMapDelegate> delegateMap;
@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) NSString *tableCellXIB;
@property (nonatomic)int tableCells_Index;
@property (nonatomic) float tableRowHeight;
@property(nonatomic)BOOL max_Cell_Star; //最后一行的状态
@property(nonatomic)BOOL is_image; //最后一行的状态
- (id)initWithStyle:(UITableViewStyle)style tableCellXIB:(NSString*)_tableCellXIB tableCells_Index:(int)_tableCells_Index;

-(void)setEnableRefresh:(BOOL)value;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
-(void) viewFrashData;
-(void)doPullRefresh;
-(void)setimage;
- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
@end
