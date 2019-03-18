//
//  LableTopViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/6/27.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LableTopViewDelegate <NSObject>
@required
-(void)closeLableTopView:(BOOL)haveChange ;
-(void)btn_OnClick:(NSMutableArray *)infolist Index:(NSInteger)_index;
@end
@interface LableTopViewController : UIViewController
{
    IBOutlet UIView  *view01;
    UIButton *btn_Recommend;
    IBOutlet UILabel *lab_MySubscribe;
    UILabel *lab_label;//点击添加
    IBOutlet UIButton *btn_Coles;
    IBOutlet UIButton *btn_Complete;
   
    NSMutableArray *arr_btnSelect;//已选按钮
    
    NSMutableArray *arr_btnNoChoice;//未选择的按钮
    
    NSMutableArray *arr_NoChoice;//未选择的按钮信息
    
    // 拖动的tile的原始center坐标
    CGPoint _dragFromPoint;
    
    // 要把tile拖往的center坐标
    CGPoint _dragToPoint;
    
    // tile拖往的rect
    CGRect _dragToFrame;
    
    // 拖拽的tile是否被其他tile包含
    BOOL _isDragTileContainedInOtherTile;
    
    // 拖拽往的目标处的tile
    UIButton *_pushedTile;
    
    //记录移动的btn
    UIButton *_movBtn;
    
    int btn_kTileWidth;
    int btn_kTileHeight;
}
@property (nonatomic ,strong)id<LableTopViewDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *lable_info;//按钮信息集合
@property(nonatomic,strong)NSMutableArray *All_lable_info;//所有按钮信息集合

@property(nonatomic)BOOL haveChange;//是否修改
@end
