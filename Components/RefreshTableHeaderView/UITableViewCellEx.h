//
//  UITableViewCellEx.h
//  YONChat
//
//  Created by SongQues on 14/11/26.
//
//

#import <UIKit/UIKit.h>
#import "UITableItem.h"
#import "UITableViewExViewDelegate.h"
#import "baiduMap.h"
@interface UITableViewCellEx : UITableViewCell
@property (nonatomic, weak) id<UITableViewExViewDelegate> delegateCustom;

@property (nonatomic, weak) id<baiduMapDelegate> delegateMap;
@property (nonatomic) int index_row;
@property (nonatomic) int currHeight;
@property (nonatomic ,strong) UITableItem *entity;
- (BOOL)configTableViewCell:(id)aObject_entity index_row:(int)aIndex_row count:(int)aCount_source;
-(void)reloadData;
@end
