//
//  ClassIficationEx.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/8/12.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClassIficationExDelegate <NSObject>
@required
-(void)Cell_OnClick:(id)Content typeView:(UIView *)typeView;
-(void)ColesTypeView:(UIView *)typeView;
@end
@interface ClassIficationEx : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *table_view;
    NSMutableArray *arr_DataList;
    NSMutableArray *arr_City;
    UIScrollView *scrollview;
    UIButton *btn_tag;
}
@property(nonatomic,weak)id<ClassIficationExDelegate> delegate;
- (id)initWithFrame:(CGRect)frame ArrList:(NSMutableArray *) arr;
@end
