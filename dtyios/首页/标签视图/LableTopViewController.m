//
//  LableTopViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/6/27.
//  Copyright © 2016年 SongQues. All rights reserved.
//


#define kTileWidth  64.f
#define kTileHeight 26.f


#import "LableTopViewController.h"

@interface LableTopViewController ()

@end

@implementation LableTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _haveChange=false;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self init_AllButton];
//    [self performSelector:@selector(init_AllButton) withObject:nil afterDelay:0.5];
    _haveChange=false;
}
-(void)init_AllButton
{
    btn_Recommend=[[UIButton alloc] init];
    [btn_Recommend setTitle:@"推荐" forState:UIControlStateNormal];
    [btn_Recommend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_Recommend setBackgroundImage:[UIImage imageNamed:@"btn_background_d_64.png"] forState:UIControlStateNormal];
    [btn_Recommend setBackgroundImage:[UIImage imageNamed:@"btn_background_s.png"] forState:UIControlStateHighlighted];
    [btn_Recommend setBackgroundImage:[UIImage imageNamed:@"btn_background_s.png"] forState:UIControlStateSelected];
    
    btn_Recommend.titleLabel.font=[UIFont systemFontOfSize:14];
    btn_Recommend.frame=CGRectMake(CGRectGetMaxX(lab_MySubscribe.frame)-lab_MySubscribe.frame.size.width, CGRectGetMaxY(lab_MySubscribe.frame)+15, kTileWidth, kTileHeight);
    btn_Recommend.tag=9999;
    //button点击事件
    [btn_Recommend addTarget:self action:@selector(btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
    //button长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress.minimumPressDuration = 0.8; //定义按的时间
    [btn_Recommend addGestureRecognizer:longPress];
    [self.view addSubview:btn_Recommend];
    //    UILabel *lab_Prompt=[[UILabel alloc]init];
    //    lab_Prompt.frame=CGRectMake(0,, <#CGFloat width#>, <#CGFloat height#>)
    arr_btnSelect=[[NSMutableArray alloc] init];
    [self Create_followButton];//添加关注按钮
    if (lab_label==nil) {
        lab_label=[[UILabel alloc] init];
        [self.view addSubview:lab_label];
    }
    lab_label.frame=CGRectMake(CGRectGetMaxX(lab_MySubscribe.frame)-lab_MySubscribe.frame.size.width,CGRectGetMaxY(view01.frame)+10, 200, 21);
    lab_label.font=[UIFont systemFontOfSize:14];
    lab_label.textColor=lab_MySubscribe.textColor;
    lab_label.text=@"点击添加";
    
    if (_All_lable_info.count==_lable_info.count)
        lab_label.hidden=YES;
    else
        lab_label.hidden=NO;
    
    NSArray *selectWrong = [_All_lable_info filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF in %@)", _lable_info]];
    arr_NoChoice=[NSMutableArray arrayWithArray:selectWrong];
    arr_btnNoChoice=[NSMutableArray array];
    if(arr_NoChoice.count>0) {
        [self Create_notFollowButton];//创建未关注按钮
    }
}
#pragma mark 创建关注按钮
-(void)Create_followButton
{
    for (int i=0;i<_lable_info.count;i++) {
        NSString *str=[_lable_info objectAtIndex:i];
        UIButton * btn_Recommend1=[[UIButton alloc] init];
        [btn_Recommend1 setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
        [btn_Recommend1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_Recommend1 setBackgroundImage:[UIImage imageNamed:@"btn_background_d_64.png"] forState:UIControlStateNormal];
        [btn_Recommend1 setBackgroundImage:[UIImage imageNamed:@"btn_background_s.png"] forState:UIControlStateHighlighted];
        [btn_Recommend1 setBackgroundImage:[UIImage imageNamed:@"btn_background_s.png"] forState:UIControlStateSelected];
        btn_Recommend1.titleLabel.font=[UIFont systemFontOfSize:14];
        if (str.length>4) {
            btn_Recommend1.titleLabel.font=[UIFont systemFontOfSize:12];
        }
        btn_Recommend1.frame=[self createFrameLayoutTile:i+1];
        btn_Recommend1.tag=i;
        //button点击事件
        [btn_Recommend1 addTarget:self action:@selector(btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        //button长按事件
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.8; //定义按的时间
        [btn_Recommend1 addGestureRecognizer:longPress];
        [self.view addSubview:btn_Recommend1];
        [arr_btnSelect addObject:btn_Recommend1];
        CGRect rec1=view01.frame;
        rec1.size.height=CGRectGetMaxY(btn_Recommend1.frame)+15;
        view01.frame=rec1;
    }
}
#pragma mark 创建未关注按钮
-(void)Create_notFollowButton
{
    for (int i=0;i<arr_NoChoice.count;i++) {
        NSString *str=[arr_NoChoice objectAtIndex:i];
        UIButton * btn_Recommend1=[[UIButton alloc] init];
        [btn_Recommend1 setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
        [btn_Recommend1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_Recommend1 setBackgroundImage:[UIImage imageNamed:@"btn_background_d_64.png"] forState:UIControlStateNormal];
        [btn_Recommend1 setBackgroundImage:[UIImage imageNamed:@"btn_background_s.png"] forState:UIControlStateHighlighted];
        [btn_Recommend1 setBackgroundImage:[UIImage imageNamed:@"btn_background_s.png"] forState:UIControlStateSelected];
        btn_Recommend1.titleLabel.font=[UIFont systemFontOfSize:14];
        if (str.length>4) {
           btn_Recommend1.titleLabel.font=[UIFont systemFontOfSize:12];
        }
        btn_Recommend1.frame=[self choiceCreateFrameLayoutTile:i];
        btn_Recommend1.tag=2000+i;
        //button点击事件
        [btn_Recommend1 addTarget:self action:@selector(btn_ChoiceOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn_Recommend1];
        [arr_btnNoChoice addObject:btn_Recommend1];
    }

}
#pragma mark 已关注标签点击
-(IBAction)btn_OnClick:(id)sender
{
    _haveChange=true;
    UIButton *btn=(UIButton *)sender;
    if(btn_Complete.hidden)
    {
        [_delegate btn_OnClick:_lable_info Index:btn.tag];
    }
    else
    {
        if (btn==btn_Recommend) {
            NSLog(@"不要删啊");
            return;
        }
        [self deletebtn];
        NSString *str=[_lable_info objectAtIndex:btn.tag];
        [_lable_info removeObjectAtIndex:btn.tag];//从选择按钮集合信息移除
        [self Create_followButton];// 重新创建选择按钮
        [self Change_ButtonState];//改变按钮状态
        NSLog(@"%@",str);
    }
}
-(void)Change_ButtonState//改变按钮的状态
{
    _haveChange=true;

    for (UIButton *btn in arr_btnSelect ) {
        if (btn!=btn_Recommend) {
            btn.selected=YES;
            btn.clipsToBounds=NO;
            UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_Close"]];
            image.frame=CGRectMake(-5,-5, 14, 14);
            image.tag=1000;
            image.backgroundColor=[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1];
            image.layer.masksToBounds=YES;
            image.layer.cornerRadius = 7;
            [btn addSubview:image];
        }
    }
}
-(IBAction)btnLong:(id)sender
{
    _haveChange=true;

    for (UIButton *btn in arr_btnSelect ) {
        if (btn!=btn_Recommend) {
            btn.selected=YES;
            btn.clipsToBounds=NO;
            UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_Close"]];
            image.frame=CGRectMake(-5,-5, 14, 14);
            image.tag=1000;
            image.backgroundColor=[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1];
            image.layer.masksToBounds=YES;
            image.layer.cornerRadius = 7;
            [btn addSubview:image];
            UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragTile:)];
            [btn addGestureRecognizer:panGestureRecognizer];
        }
    }
    btn_Coles.hidden=YES;
    btn_Complete.hidden=NO;
    for (int i=0;i<arr_btnNoChoice.count;i++) {
        UIButton *btn=[arr_btnNoChoice objectAtIndex:i];
        [btn setHidden:YES];
    }
    lab_label.hidden=YES;
}
- (BOOL)dragTile:(UIPanGestureRecognizer *)recognizer
{
    _haveChange=true;

    switch ([recognizer state])
    {
        case UIGestureRecognizerStateBegan:
            [self dragTileBegan:recognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragTileMoved:recognizer];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragTileEnded:recognizer];
            break;
        default: break;
    }
    return YES;
}
- (void)dragTileBegan:(UIPanGestureRecognizer *)recognizer
{
    _haveChange=true;

    _dragFromPoint = recognizer.view.center;
    _movBtn=(UIButton *)recognizer.view;
    [UIView animateWithDuration:0.2f animations:^{
        recognizer.view.transform = CGAffineTransformMakeScale(1.05, 1.05);
        recognizer.view.alpha = 0.8;
    }];
}

- (void)dragTileMoved:(UIPanGestureRecognizer *)recognizer
{
    _haveChange=true;

    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    [self rollbackPushedTileIfNecessaryWithPoint:recognizer.view.center];
    [self pushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIButton *)recognizer.view];
}

- (void)rollbackPushedTileIfNecessaryWithPoint:(CGPoint)point
{
    _haveChange=true;

    if (_pushedTile && !CGRectContainsPoint(_dragToFrame, point))
    {
        [UIView animateWithDuration:0.2f animations:^{
            _pushedTile.center = _dragToPoint;
        }];
        
        _dragToPoint = _dragFromPoint;
        _pushedTile = nil;
        _isDragTileContainedInOtherTile = NO;
    }
}

- (void)pushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIButton *)tileView
{
    _haveChange=true;

    for (UIButton *item in arr_btnSelect)
    {
        if (CGRectContainsPoint(item.frame, tileView.center) && item != tileView)
        {
            _dragToPoint = item.center;
            _dragToFrame = item.frame;
            _pushedTile = item;
            _isDragTileContainedInOtherTile = YES;
            
            [UIView animateWithDuration:0.2 animations:^{
                item.center = _dragFromPoint;
            }];
            break;
        }
    }
  
}

- (void)dragTileEnded:(UIPanGestureRecognizer *)recognizer
{
    _haveChange=true;

    [UIView animateWithDuration:0.2f animations:^{
        recognizer.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
        recognizer.view.alpha = 1.f;
    }];
    
    [UIView animateWithDuration:0.2f animations:^{
        if (_isDragTileContainedInOtherTile)
        {
          recognizer.view.center = _dragToPoint;
          [_lable_info exchangeObjectAtIndex:_movBtn.tag withObjectAtIndex:_pushedTile.tag];//调换数组的元素
          [arr_btnSelect exchangeObjectAtIndex:_movBtn.tag withObjectAtIndex:_pushedTile.tag];
           for (int i=0; i<arr_btnSelect.count; i++) {
                UIButton *btn=[arr_btnSelect objectAtIndex:i];
                btn.tag=i;
            }
        }
        else
            recognizer.view.center = _dragFromPoint;
    }];
    
    _pushedTile = nil;
    _isDragTileContainedInOtherTile = NO;
}
#pragma mark 未关注标签点击
-(IBAction)btn_ChoiceOnClick:(id)sender
{
    _haveChange=true;

    [self deletebtn];
    UIButton *btn=(UIButton *)sender;
    NSString *srt=[arr_NoChoice objectAtIndex:btn.tag-2000];
    [arr_NoChoice removeObjectAtIndex:btn.tag-2000];
    [_lable_info addObject:srt];
    [self init_AllButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BtnColes_OnClick:(id)sender
{
    [_delegate closeLableTopView:_haveChange];
}
#pragma mark 编辑完成的方法
-(IBAction)BtnComplete_OnClick:(id)sender
{
    _haveChange=true;

    for (int i=0;i<arr_btnSelect.count;i++) {
        UIButton *btn=[arr_btnSelect objectAtIndex:i];
        [btn removeFromSuperview];
    }
    [arr_btnSelect removeAllObjects];
    [self init_AllButton];
    btn_Coles.hidden=NO;
    btn_Complete.hidden=YES;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 计算已关注btn坐标
- (CGRect)createFrameLayoutTile :(int)counter
{
    CGRect rect;
    int startY= CGRectGetMaxY(btn_Recommend.frame)-btn_Recommend.frame.size.height;
    int startX=CGRectGetMaxX(btn_Recommend.frame)-btn_Recommend.frame.size.width;
    int row=(counter/4);
    int marginTop = startY+(row *(24+8)) ;
    
    float interval=((bounds_width.size.width-startX*2)-kTileWidth*4)/3;
    if (counter % 4==0) {
        rect= CGRectMake(startX, marginTop,kTileWidth,kTileHeight);
    }
    else if (counter % 4==1)
    {
       rect= CGRectMake(startX+kTileWidth+interval, marginTop,kTileWidth,kTileHeight);
    }
    else if (counter % 4==2)
    {
        rect= CGRectMake(startX+(kTileWidth+interval)*2, marginTop,kTileWidth, kTileHeight);
    }
    else
    {
       rect= CGRectMake(startX+(kTileWidth+interval)*3, marginTop,kTileWidth, kTileHeight);
    }
    return rect;
}
#pragma mark 计算未关注btn坐标
- (CGRect)choiceCreateFrameLayoutTile :(int)counter
{
    CGRect rect;
    int startY= CGRectGetMaxY(lab_label.frame)+10;
    int startX=CGRectGetMaxX(lab_label.frame)-lab_label.frame.size.width;
    int row=(counter/4);
    int marginTop = startY+(row *(24+8)) ;
    float interval=((bounds_width.size.width-startX*2)-kTileWidth*4)/3;
    if (counter % 4==0) {
        rect= CGRectMake(startX, marginTop,kTileWidth,kTileHeight);
    }
    else if (counter % 4==1)
    {
        rect= CGRectMake(startX+kTileWidth+interval, marginTop,kTileWidth,kTileHeight);
    }
    else if (counter % 4==2)
    {
        rect= CGRectMake(startX+(kTileWidth+interval)*2, marginTop,kTileWidth, kTileHeight);
    }
    else
    {
        rect= CGRectMake(startX+(kTileWidth+interval)*3, marginTop,kTileWidth, kTileHeight);
    }
    return rect;
}
#pragma mark
-(void)deletebtn
{
    for (int i=0;i<arr_btnSelect.count;i++) {
        UIButton *btn=[arr_btnSelect objectAtIndex:i];
        [btn removeFromSuperview];
    }
    for (int i=0;i<arr_btnNoChoice.count;i++) {
        UIButton *btn=[arr_btnNoChoice objectAtIndex:i];
        [btn removeFromSuperview];
    }
    [arr_btnSelect removeAllObjects];
    [arr_btnNoChoice removeAllObjects];
}
@end
