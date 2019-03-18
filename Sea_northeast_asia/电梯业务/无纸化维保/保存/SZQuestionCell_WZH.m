//
//  SZQuestionCell_WZH.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/7/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "SZQuestionCell_WZH.h"
#import "SZConfigure.h"
#import "SZQuestionItem.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "SZQuestionCheckBox_WZH.h"
@interface SZQuestionCell_WZH ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) NSDictionary *contentDict;

@property (nonatomic, strong) NSArray *letterArray;

@property (nonatomic, strong) NSArray *buttonArray;

@property (nonatomic, assign) NSInteger questionNum;

@property (nonatomic, assign) NSArray * IsNFCOKArr;

@property (nonatomic, assign)  SZQuestionItemType type;

@property (nonatomic, strong) SZConfigure *configure;

// configure 属性

@property (nonatomic, assign) CGFloat titleFont;

@property (nonatomic, assign) CGFloat optionFont;

@property (nonatomic, strong) UIColor *backColor;

@property (nonatomic, strong) UIColor *titleTextColor;

@property (nonatomic, strong) UIColor *optionTextColor;

@property (nonatomic, assign) CGFloat oneLineHeight;

@property (nonatomic, assign) CGFloat topDistance;

@property (nonatomic, assign) CGFloat titleSideMargin;

@property (nonatomic, assign) CGFloat optionSideMargin;

@property (nonatomic, assign) CGFloat buttonSize;

@property (nonatomic, copy) NSString *checkedImage;

@property (nonatomic, copy) NSString *unCheckedImage;

@end



@implementation SZQuestionCell_WZH
@synthesize delegateCustom;
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDict:(NSDictionary *)contentDict andQuestionNum:(NSInteger)questionNum andWidth:(CGFloat)width andConfigure:(SZConfigure *)configure forIsNfc:(NSArray * )IsNFCOKArr{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.configure      = configure;
        self.contentDict    = contentDict;
        self.questionNum    = questionNum;
        self.type           = [contentDict[@"type"] integerValue];
        self.IsNFCOKArr     = IsNFCOKArr;
        [self setupLayoutWithDict:contentDict andWidth:width];
    }
    return self;
}

- (void)setConfigure:(SZConfigure *)configure {
    
    _configure = configure;
    self.titleFont      = configure.titleFont ? configure.titleFont : 17;
    self.optionFont     = configure.optionFont ? configure.optionFont : 16;
    self.oneLineHeight  = configure.oneLineHeight ? configure.oneLineHeight : OPEN_OPTION_CELL_H;
    self.topDistance    = configure.topDistance ? configure.topDistance : 5;
    self.buttonSize     = configure.buttonSize ? configure.buttonSize : BUTTON_WIDTH;
    self.checkedImage   = configure.checkedImage ? configure.checkedImage : @"checked";
    self.unCheckedImage = configure.unCheckedImage ? configure.unCheckedImage : @"unchecked";
    self.backColor      = configure.backColor ? configure.backColor : [UIColor whiteColor];
    self.titleTextColor   = configure.titleTextColor ? configure.titleTextColor : [UIColor blackColor];
    self.optionSideMargin = configure.optionSideMargin  ? configure.optionSideMargin : OPTION_MARGIN;
    self.titleSideMargin  = configure.titleSideMargin ? configure.titleSideMargin : HEADER_MARGIN;
    self.optionTextColor  = configure.optionTextColor ? configure.optionTextColor : [UIColor blackColor];
}


- (void)tongzhi_warn:(NSNotification *)text{
    NSString *ifNfcOk=(NSString *)text.userInfo[@"ifNfcOk"];
    NSString *index=(NSString *)text.userInfo[@"index"];
    
    if([index intValue]!=self.questionNum-1)return;
    
    if([ifNfcOk isEqual:@"1"])
    {
        [self performSelectorOnMainThread:@selector(showNFCHave:) withObject:[NSString stringWithFormat:@"%ld", self.questionNum] waitUntilDone:YES];
        //[self showNFCHave:[NSString stringWithFormat:@"%ld", self.questionNum]];
    }
    else
    {
        [self showNFCno:[NSString stringWithFormat:@"%ld", self.questionNum]];
    }
}

- (void)setupLayoutWithDict:(NSDictionary *)dict andWidth:(CGFloat)width{
    
    //    13.2注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_warn:) name:@"tongzhi_NFCSBCell" object:nil];
    
    NSLog(@"%@",dict);
    
    
    
    CGFloat titleWidth = width - self.titleSideMargin * 2;
    CGFloat optionWidth = width - self.optionSideMargin * 2 - self.buttonSize - 5;
    self.topDistance = self.questionNum == 1 ? self.topDistance : 5;
    self.backgroundColor = self.backColor;
    // 标题
    CGFloat height = [SZQuestionItem heightForString:dict[@"title"] width:titleWidth fontSize:self.titleFont oneLineHeight:self.oneLineHeight];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleSideMargin, self.topDistance, titleWidth, height)];
    titleLabel.textColor = self.titleTextColor;
    titleLabel.font = [UIFont systemFontOfSize:15];//self.titleFont];
    int num = [dict[@"type3"] intValue]+1;
    titleLabel.text = [NSString stringWithFormat:@"%d、%@",num,dict[@"title"]];
    
    titleLabel.numberOfLines = 0;
    [self addSubview:titleLabel];
    
    // 选项或回答框
    if ([dict[@"type"] intValue] == SZQuestionOpenQuestion) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(self.optionSideMargin, height + self.topDistance, width - self.optionSideMargin * 2, self.oneLineHeight - 10)];
        textField.font = [UIFont systemFontOfSize:self.optionFont];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.textColor = self.optionTextColor;
        textField.delegate = self;
        if (dict[@"marked"] != nil) {
            textField.text = dict[@"marked"];
        }
        [self addSubview: textField];
    }
    else {
        // 回答框
        UIView *backView;
        UILabel *currentLabel;
        NSMutableArray *tempArray = [NSMutableArray array];
        NSArray *optionArray = dict[@"option"];
        NSArray *selectArray = dict[@"marked"];
        
        float heightAll=0;
        
        
        backView = [[UIView alloc] initWithFrame:CGRectMake(self.optionSideMargin, height+5, width - self.optionSideMargin * 2,30)];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = 6.0;
        // backView.backgroundColor=[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
        backView.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self addSubview: backView];
        
        //nfc
        int nfcwidth=0;
        bool isnfc= [dict[@"IsNFC"] boolValue];
        
        if(isnfc)
        {
            nfcwidth=100;
            self.view_Nfc=[[UIView alloc]initWithFrame: CGRectMake(self.optionSideMargin, height+5, nfcwidth,heightAll)];
            [self addSubview:self.view_Nfc];
        }
        
        for (int i = 0; i < optionArray.count; i++) {
            
            
            CGFloat option_height = [SZQuestionItem heightForString:optionArray[i] width:optionWidth fontSize:self.optionFont oneLineHeight:self.oneLineHeight];
            
            heightAll+=option_height;
            if (currentLabel == nil) {
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.optionSideMargin + self.buttonSize + 5+nfcwidth, height + self.topDistance, optionWidth, option_height)];
                lbl.numberOfLines = 0;
                lbl.textColor = [UIColor colorWithHexString:@"#666666"];
                lbl.font = [UIFont systemFontOfSize:15];;//self.optionFont
                lbl.text = [NSString stringWithFormat:@"%@、%@", self.letterArray[i], optionArray[i]];
                [self addSubview:lbl];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.optionSideMargin+nfcwidth, height + self.topDistance + 5, width - self.optionSideMargin * 2, self.buttonSize)];
                //[btn setImage:[UIImage imageNamed:self.unCheckedImage] forState:UIControlStateNormal];
                ///[btn setImage:[UIImage imageNamed:self.checkedImage] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                btn.selected = selectArray.count > 0 ? [selectArray[i] boolValue] : NO;
                btn.tag = [[dict objectForKey:@"type3"] integerValue];
                
                UIImageView *btnImage=[[UIImageView alloc]initWithFrame:CGRectMake(3, 5, self.buttonSize-6, self.buttonSize-6)];
                if (btn.isSelected) {
                    btnImage.image=[UIImage imageNamed:self.checkedImage];
                }
                else{
                    btnImage.image=[UIImage imageNamed:self.unCheckedImage];
                }
                btnImage.tag=1000;
                [btn addSubview:btnImage];
                
                [self  addSubview:btn];
                [tempArray addObject:btn];
                
                currentLabel = lbl;
            }
            else {
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.optionSideMargin + self.buttonSize + 5+nfcwidth, CGRectGetMaxY(currentLabel.frame), optionWidth, option_height)];
                lbl.numberOfLines = 0;
                lbl.textColor = [UIColor colorWithHexString:@"#666666"];
                lbl.font = [UIFont systemFontOfSize:15];//self.optionFont
                lbl.text = [NSString stringWithFormat:@"%@、%@", self.letterArray[i], optionArray[i]];
                [self addSubview:lbl];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.optionSideMargin+nfcwidth, CGRectGetMaxY(currentLabel.frame) + 5, width - self.optionSideMargin * 2, self.buttonSize)];
                //[btn setImage:[UIImage imageNamed:self.unCheckedImage] forState:UIControlStateNormal];
                //[btn setImage:[UIImage imageNamed:self.checkedImage] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = [[dict objectForKey:@"type3"] integerValue];
                btn.selected = selectArray.count > 0 ? [selectArray[i] boolValue] : NO;
                
                UIImageView *btnImage=[[UIImageView alloc]initWithFrame:CGRectMake(3, 5, self.buttonSize-6, self.buttonSize-6)];
                if (btn.isSelected) {
                    btnImage.image=[UIImage imageNamed:self.checkedImage];
                }
                else{
                    btnImage.image=[UIImage imageNamed:self.unCheckedImage];
                }
                btnImage.tag=1000;
                [btn addSubview:btnImage];
                
                [self addSubview:btn];
                [tempArray addObject:btn];
                
                currentLabel = lbl;
            }
            
            UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, heightAll, backView.frame.size.width, 1)];
            line1.backgroundColor=[UIColor colorWithHexString:@"#e0e0e0"];
            [backView addSubview:line1];
        }
        self.buttonArray = tempArray.copy;
       
        //nfc
        self.view_Nfc.frame=CGRectMake(self.optionSideMargin, height+5,nfcwidth,heightAll);
        if(isnfc)
        {
            //NSString *index=[NSString stringWithFormat:@"%d",num];
            NSString *strC= @"nfc_c_no";
            NSString *namefnc=dict[@"TermName"];
            [self addButton:strC forName:namefnc forTag:num forView:self.view_Nfc];
            
            if([[_IsNFCOKArr valueForKey:[NSString stringWithFormat:@"%ld",self.questionNum-1]] isKindOfClass: [NSString class]])
            {
            if([[_IsNFCOKArr valueForKey:[NSString stringWithFormat:@"%ld",self.questionNum-1]] isEqual:@"1"])
            { [self showNFCHave:[NSString stringWithFormat:@"%ld", self.questionNum]];}
            }
            
        }
        
        backView.frame=CGRectMake(self.optionSideMargin+nfcwidth, height+5, width - self.optionSideMargin * 2-nfcwidth,heightAll);
        
        // 回答框
        UIView *tecView=[[UIView alloc]initWithFrame:CGRectMake(self.optionSideMargin, heightAll+height+10, width - self.optionSideMargin * 2,42)];//30
        tecView.layer.borderWidth=1.0;
        tecView.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
        tecView.layer.masksToBounds=YES;
        tecView.layer.cornerRadius=5.0;
        [self addSubview:tecView];
        
        //        UIImageView *imView=[[UIImageView alloc]initWithFrame:CGRectMake(self.optionSideMargin+10, heightAll+height+15, 15, 15)];
        //        imView.image=[UIImage imageNamed:@"view"];
        //        [self addSubview:imView];
        
        
        
        
        
        if([[dict objectForKey:@"type2"] integerValue]==1)
        {
            self.textField1 = [[UITextView alloc] initWithFrame:CGRectMake(self.optionSideMargin+10, heightAll+height+10+1,width - self.optionSideMargin * 2-45 ,40)];//30
            [self addSubview: self.textField1];
            
            tecView.frame=CGRectMake(self.optionSideMargin, heightAll+height+10, width - self.optionSideMargin * 2-30,42);//30
            
            UIImageView *xj=[[UIImageView alloc]initWithFrame:CGRectMake(width-self.optionSideMargin-25, self.textField1.frame.origin.y+10, 25, 25)];
            xj.image=[UIImage imageNamed:@"wyxc_camera"];
            [self addSubview: xj];
        }
        else
        {
            self.textField1 = [[UITextView alloc] initWithFrame:CGRectMake(self.optionSideMargin+10, heightAll+height+10+1, width - self.optionSideMargin * 2-15,40)];//30
            [self addSubview: self.textField1];
        }
        
        self.textField1.font = [UIFont systemFontOfSize:self.optionFont];
        self.textField1.delegate = self;
        //self.textField1.placeholder =@"写下您的意见";
        self.textField1.text =@"写下您的意见";
        self.textField1.textColor= [UIColor lightGrayColor];
    }
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_photo_nfc:) name:@"tongzhi_photo_nfc" object:nil];
    
}

- (void)tongzhi_photo_nfc:(NSNotification *)text{
    int numbers=0;
    numbers=[text.userInfo[@"textOne"] intValue];
    
    if(self.questionNum - 1==numbers)
    {
    NSString*  IsNFCOK=@"1";
//    [CommonUseClass showAlter:@"拍照成功！"];
    [self showNFCHave:[NSString stringWithFormat:@"%ld", self.questionNum]];
    
    self.selectNFCBack(self.questionNum - 1, IsNFCOK);
    }
}


- (void)textViewDidBeginEditing:(UITextView*)textView {
    
    if([self.textField1.text isEqualToString:@"写下您的意见"]) {
        
        self.textField1.text=@"";
        
        self.textField1.textColor= [UIColor blackColor];
        
    }
    
}

- (void)textViewDidEndEditing:(UITextView*)textView {
    
    if(self.textField1.text.length<1) {
        
        self.textField1.text=@"写下您的意见";
        
        self.textField1.textColor= [UIColor lightGrayColor];
        
    }
    
}




#pragma mark - UITextFieldDelegate



#pragma mark -  UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([self.typeStr isEqualToString:@"1"]) {
        return NO;
    }
    return YES;
}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    return YES;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.textField1 == textField) {
        return YES;
    }
    
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc] initWithDictionary:self.contentDict];
    dictM[@"newMarked"] = textField.text;
    self.selectOptionBack(self.questionNum - 1, dictM.copy);
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.textField1 == textField) {
        self.selecttextfieldBack(self.questionNum - 1, textField.text);
    }
}
- (void)clickButton:(UIButton *)sender {
    if(sender.selected==NO)
        sender.selected = !sender.selected;
    
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc] initWithDictionary:self.contentDict];
    
    NSLog(@"+++++++%@",[dictM objectForKey:@"type2"]);
    
    if (self.type == SZQuestionSingleChoice) {
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (UIButton *btn in self.buttonArray) {
            
            UIImageView *imag1e=(UIImageView*)[btn viewWithTag:1000];
            imag1e.image=[UIImage imageNamed:self.unCheckedImage];
            
            if (btn != sender) {
                btn.selected = NO;
            }
            else{
                
                if (sender.selected) {
                    imag1e.image=[UIImage imageNamed:self.checkedImage];
                    
                }
            }
            [tempArray addObject:@(btn.selected)];
        }
        dictM[@"marked"] = tempArray.copy;
    }
    else {
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (UIButton *btn in self.buttonArray) {
            
            [tempArray addObject:@(btn.selected)];
        }
        dictM[@"marked"] = tempArray.copy;
    }
    
    NSArray * selectArr= dictM[@"marked"];
    
    
    if([[selectArr firstObject] integerValue] == 0)//不合格：照相
    {
        [self btn_PhotoClcik:sender addType:[dictM objectForKey:@"type2"] addPhoto:nil];
    }
    else
    {
        if ([[dictM objectForKey:@"type2"] intValue] != 0) {
            
            [self btn_PhotoClcik:sender addType:[dictM objectForKey:@"type2"] addPhoto:nil];
        }
        else
        {
            [self btn_PhotoClcik:sender addType:[dictM objectForKey:@"type2"] addPhoto:@"noPhoto"];
        }
    }
    
    self.selectOptionBack(self.questionNum - 1, dictM.copy);
}

- (void)btn_PhotoClcik:(UIButton *)btn addType:(NSString *)type addPhoto:(NSString *)photo
{
    if (_delegate) {
        
        [self.delegate attentionButtonClick:btn clickedWithData:type clickedWithPhoto:photo];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    for (UIView *v in [UIApplication sharedApplication].keyWindow.subviews) {
        [v endEditing:YES];
    }
}

- (NSArray *)letterArray {
    
    if (_letterArray == nil) {
        _letterArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    }
    return _letterArray;
}
-(void)addButton:(NSString *)ConterImg forName:(NSString *)name forTag:(int)tag forView:(UIView*)view
{
    
    self.img_head33=[MyControl createImageViewWithFrame:CGRectMake((view.frame.size. width-60)/2,0,  60, 60) imageName:ConterImg];
    self.img_head33.tag=2000+tag;
    [view addSubview:self.img_head33];
    
    UILabel *dttext = [MyControl createLabelWithFrame:CGRectMake(0, 55, view.frame.size. width, 34) Font:14 Text:name];
    dttext.numberOfLines=2;
    dttext.textAlignment=NSTextAlignmentCenter;
    [view addSubview:dttext];
    
    UIButton *btnBand= [MyControl createButtonWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) imageName:nil bgImageName:nil title:nil SEL:@selector(btnClick_band:) target:self];
    btnBand.tag=tag;
    [view addSubview:btnBand];
}

- (void)btnClick_band:(UIButton *)btn
{
//    //test
//    //[self save:@"001" forGuid:@"9FE095021E2B01" ];
//    [self save:@"" forGuid:@"" ];
//    return;
//    //test
    
    
    /**
     三个参数
     第一个参数：代理对象
     第二个参数：线程
     第三个参数：Session读取一个还是多个NDEF。YES：读取一个结束，NO：读取多个
     */
    NFCNDEFReaderSession *session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT) invalidateAfterFirstRead:YES];
    
    [session beginSession];
}

/**
 具体父子关系看官方文档
 */
- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error
{
    if(error.code==1)
    {
        [self performSelectorOnMainThread:@selector(showMsg) withObject:nil waitUntilDone:YES];
    }
}


-(void)showMsg{
//    UIButton *btn=[[UIButton alloc]init];
//    btn.tag=self.questionNum - 1;
//    [self btn_PhotoClcik:btn addType:@"nfc" addPhoto:nil];
//    [MBProgressHUD showError:@"扫描失败,非NFC设备。请拍照!" toView:nil];//（注：NFC扫描需要设备在IPONE7及以上，并且系统版本在iOS 11及以上！）
    

    

    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_contentDict[@"TermName"],@"text1", @"",@"text2", [NSString stringWithFormat:@"%ld", self.questionNum - 1],@"text3",
        self.contentDict[@"NFCCode"],@"NFCCode",self.contentDict[@"NFCNum"],@"NFCNum",                 nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_NFCSBShow" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    
}
- (void) readerSession:(nonnull NFCNDEFReaderSession *)session didDetectNDEFs:(nonnull NSArray<NFCNDEFMessage *> *)messages {
    
    for (NFCNDEFMessage *message in messages) {
        for (NFCNDEFPayload *payload in message.records) {
            NSLog(@"Payload data:%@",payload.payload);
            NSData *newdata=payload.payload;
            newdata= [newdata subdataWithRange:NSMakeRange(3, newdata.length-3)];
            NSString *str=[[ NSString alloc] initWithData:newdata encoding:NSUTF8StringEncoding];
            NSLog(@"Payload str:%@",str);
            guid=[CommonUseClass getID:session];
            
            //2.
             [self performSelectorOnMainThread:@selector(save:) withObject:str waitUntilDone:YES];
            //[self save:str forGuid:guid];
        }
    }
}

//-(void)save:(NSString *)nfccode forGuid:(NSString *)guid {
-(void)save:(NSString *)nfccode  {
    NSString * IsNFCOK=@"0";
    if([guid isEqual:self.contentDict[@"NFCNum"]])//[nfccode isEqual:self.contentDict[@"NFCCode"]]&&
    {
        IsNFCOK=@"1";
        [CommonUseClass showAlter:@"识别成功！"];
        [self showNFCHave:[NSString stringWithFormat:@"%ld", self.questionNum]];
    }
    else
    {
        IsNFCOK=@"0";
        [CommonUseClass showAlter:@"该标签为错误标签，请重新扫描！"];
         [self showNFCno:[NSString stringWithFormat:@"%ld", self.questionNum]];
    }
    
    self.selectNFCBack(self.questionNum - 1, IsNFCOK);
}

-(void)showNFCHave:(NSString *)index
{
    UIImageView *imgC =self.img_head33;// (UIImageView *)[self viewWithTag:(2000+[index intValue])];
    NSString *strC= [@"nfc_c_" stringByAppendingString:index];
    imgC.image=[UIImage imageNamed:strC];
}

-(void)showNFCno:(NSString *)index
{
    UIImageView *imgC =self.img_head33;// (UIImageView *)[self viewWithTag:(2000+[index intValue])];
    NSString *strC= @"nfc_c_no";
    imgC.image=[UIImage imageNamed:strC];
}
@end
