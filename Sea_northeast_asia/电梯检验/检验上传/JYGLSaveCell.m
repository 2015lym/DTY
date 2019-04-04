//
//  JYGLSaveCell.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/28.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "JYGLSaveCell.h"
#import "warningElevatorModel.h"
#import "JYGLSave.h"
@interface JYGLSaveCell ()
{
    NSMutableDictionary * warnmodel;
}
@end

@implementation JYGLSaveCell
@synthesize app;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void )saveThisValue:(NSMutableDictionary *)newdic
{
    warnmodel=newdic;
    for (int i =0;i< app.arrData.count;i++) {
        NSDictionary *dic=app.arrData[i];
        if(dic[@"StepId"]==newdic[@"StepId"])
        {
            app.arrData[i]=newdic;
            break;
        }
    }
}

-(void)setThisValue:(NSArray *)array
{
    for (NSDictionary *dic in array) {
        if([dic[@"InspectId"] isEqual: warnmodel[@"InspectId"]]
           &&[[CommonUseClass FormatString: dic[@"StepId"]] isEqual:[CommonUseClass FormatString: warnmodel[@"StepId"]]])
        {
            //1.
            [warnmodel setObject:@"1" forKey:@"IsOutLine"];
            [warnmodel setObject:dic[@"Remark"] forKey:@"Remark"];
            
            //2.
            if([[CommonUseClass FormatString: [dic objectForKey:@"IsPhoto"]] isEqual:@"1"] )
            {
                if([dic[@"have_online_phone"] isEqual:@"1"])
                {
                    NSData *data= [dic objectForKey:@"online_phone"];
                    UIImage *imageNew =[UIImage imageWithData: data];
                    [warnmodel setObject:imageNew forKey:@"online_phone"];
                    [warnmodel setObject:@"1" forKey:@"have_online_phone"];
                }
            }
            if([[CommonUseClass FormatString: [dic objectForKey:@"IsVideo"]] isEqual:@"1"])
            {
                NSString *this_video_url=[CommonUseClass FormatString: [dic objectForKey:@"online_video_url"]];
                [warnmodel setObject:this_video_url forKey:@"online_video_url"];
            }
            
            //3.
            NSString *jsonstr=[dic objectForKey:@"TemplateAttributeJson"];
            NSArray *jsonArray;
            if(![[CommonUseClass FormatString:jsonstr] isEqual:@""] )
            {
                jsonArray= [jsonstr objectFromJSONString];
            }
            
            if(![[CommonUseClass FormatString:[warnmodel objectForKey:@"InspectTemplateAttributeEntityList"]] isEqual:@""] )
            {
            NSMutableArray *arrayOther=[[warnmodel objectForKey:@"InspectTemplateAttributeEntityList"] mutableCopy];
            
                NSMutableArray *arrayOtherNew=[NSMutableArray new];
                for (NSDictionary *dicOld in arrayOther) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dicOld];
                    
                    for (NSDictionary *dicJson in jsonArray) {
                        if([dicJson[@"ID"] isEqual:dic[@"ID"]])
                        {
                            [dic setValue:dicJson[@"InputValue"] forKey:@"InputValue"];
                            break;
                        }
                    }
                    
                    [arrayOtherNew addObject:dic];
                }
                [warnmodel setValue:arrayOtherNew forKey:@"InspectTemplateAttributeEntityList"];
            }
            return;
        }
    }
   
}

- (BOOL)configTableViewCell:(id)aObject_entity index_row:(int)aIndex_row count:(int)aCount_source;
{
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    //1.all set
    self.backgroundColor=[UIColor whiteColor];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, bounds_width.size.width,self.frame.size.height+50);
    self.currHeight=175;
    self.selectionStyle= UITableViewCellSelectionStyleNone;
    
    //2.data
    NSDictionary * warnmodel0=(NSDictionary *)aObject_entity;
    warnmodel = [NSMutableDictionary dictionaryWithDictionary:warnmodel0];
    //2.1 have this data
    NSDictionary *dic=nil;
    for (int i =0;i< app.arrData.count;i++) {
        dic=app.arrData[i];
        if(dic[@"StepId"]==warnmodel[@"StepId"])
        {
            break;
        }
    }
    if(dic!=nil)
    {
        warnmodel = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    //2.2 set this value
    
    
   if(![[CommonUseClass FormatString: warnmodel[@"isSetThisValue"]]isEqual:@"1"])
   {
       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       NSArray *array0 = [defaults objectForKey:@"Datajianyan"] ;
       [self setThisValue:array0];
       [warnmodel setValue:@"1" forKey:@"isSetThisValue"];
       [self saveThisValue:warnmodel];
   }
    
   _labTitle.text=[NSString stringWithFormat:@"%@、%@", [warnmodel objectForKey:@"ID"] ,[warnmodel objectForKey:@"StepName"]];
    _labConcent.text=[CommonUseClass FormatString:[warnmodel objectForKey:@"Remark"]];
    _labConcent.returnKeyType = UIReturnKeyDone;
    _labConcent.tag=2000;
    _labConcent.delegate=self;
    [self setImg_photo];
    
    [self setImg_servrerFile];
    [self setImg_thisFile];
//    [self setImg_lock];
    [self showoutLine];
   
    //3.button
    //3.1 确认
    _btn_look.layer.borderColor= [UIColor orangeColor].CGColor;
    _btn_look.layer.borderWidth=1.0f;
    _btn_look.layer.masksToBounds = YES;
    _btn_look.layer.cornerRadius = 4;
    [_btn_look setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_btn_look addTarget:self action:@selector(dianZanBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //3.2 serverFile
    [_btn_serverFile addTarget:self action:@selector(btnclick_serverFile:) forControlEvents:UIControlEventTouchUpInside];
    //3.3 thisFile
    [_btn_thisFile addTarget:self action:@selector(btnclick_thisFile:) forControlEvents:UIControlEventTouchUpInside];
    //3.4 photo
    [_btn_photo addTarget:self action:@selector(btnclick_photo:) forControlEvents:UIControlEventTouchUpInside];
    //3.5 outline
    [_btn_outLine addTarget:self action:@selector(btnclick_outLine:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加手势
    UITapGestureRecognizer *Add_TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(View_AddTap:)];
    //将触摸事件添加到当前view
    [self.contentView addGestureRecognizer:Add_TapGesture];
    
    
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_warn:) name:@"thisVideo" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_Dater:) name:@"thisDater" object:nil];
    
    NSMutableArray *arrayOther=[warnmodel objectForKey:@"InspectTemplateAttributeEntityList"];
    
    if(![[CommonUseClass FormatString:[warnmodel objectForKey:@"InspectTemplateAttributeEntityList"]] isEqual:@""] &&arrayOther.count>0)
    {
        int top=CGRectGetMaxY(_labConcent.frame);
        
        for (NSDictionary *dic in arrayOther) {

            NSString *name=[NSString stringWithFormat:@"%@", dic[@"AttributeName"] ];
            NSString *AttributeUnits=[CommonUseClass FormatString: [NSString stringWithFormat:@"%@", dic[@"AttributeUnits"] ]];
            if(![AttributeUnits isEqual:@""])
            {
                name=[NSString stringWithFormat:@"%@(%@)",name,AttributeUnits];
            }
            
            UITextField * textOther=[MyControl createTextFildWithFrame:CGRectMake(10, top+5, SCREEN_WIDTH-20, 30) Font:15 Text:dic[@"InputValue"]];
            textOther.tag=1000+[dic[@"ID"] intValue];
            [self.contentView addSubview:textOther];
            textOther.layer.borderColor= [UIColor lightGrayColor].CGColor;
            textOther.layer.borderWidth=1.0f;
            textOther.layer.masksToBounds = YES;
            textOther.layer.cornerRadius = 4;
            textOther.delegate=self;
            textOther.placeholder=name;
             textOther.returnKeyType = UIReturnKeyDone;
            if([dic[@"AttributeType"] isEqual:@"文本"])
            {
                
            }
            else  if([dic[@"AttributeType"] isEqual:@"日期"])
            {
                textOther.enabled=NO;
                
                UIButton *btn=[MyControl createButtonWithFrame:textOther.frame imageName:nil bgImageName:nil title:@"" SEL:@selector(date_select:) target:self];
                btn.tag=3000+[dic[@"ID"] intValue];
                 [self.contentView addSubview:btn];
            }
            
            top=top+40;
        }
        self.currHeight=175+(int)arrayOther.count*40;
        _btn_look.frame=CGRectMake(_btn_look.frame.origin.x, self.currHeight-40, _btn_look.frame.size.width, _btn_look.frame.size.height);
        _line.frame=CGRectMake(0, self.currHeight-1, _line.frame.size.width, 1);
    }
    

    
    return YES;
    
}

- (void)tongzhi_warn:(NSNotification *)text{
    NSString *myid=(NSString *)text.userInfo[@"textOne"];
    if([myid intValue]!= [warnmodel[@"StepId"] intValue])return;
    NSString *url=(NSString *)text.userInfo[@"texturl"];
    //2.
    NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:warnmodel];
    [newdic setObject:url forKey:@"this_video_url"];
    [self saveThisValue:newdic];
    
    _img_thisFile.image=[UIImage imageNamed:@"ic_maintenance_photo2sel"];
}

- (void)tongzhi_Dater:(NSNotification *)text{
    NSString *myid=(NSString *)text.userInfo[@"textOne"];
    if([myid intValue]!= [warnmodel[@"StepId"] intValue])return;
    NSString *value=(NSString *)text.userInfo[@"textTwo"];
    myid=(NSString *)text.userInfo[@"Daterid_listid"];
    //2.
    NSMutableArray *arrayOther=[[warnmodel objectForKey:@"InspectTemplateAttributeEntityList"] mutableCopy];
    NSMutableArray *arrayOtherNew=[NSMutableArray new];
    for (NSDictionary *dicOld in arrayOther) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dicOld];
        int tag=3000+[dic[@"ID"] intValue];
        if([myid intValue] ==tag)
        {
            [dic setValue:value forKey:@"InputValue"];
        }
        [arrayOtherNew addObject:dic];
    }
    [warnmodel setValue:arrayOtherNew forKey:@"InspectTemplateAttributeEntityList"];

    //3.
    int tag=[myid intValue]-2000;
    UITextField *textOther=[self.contentView viewWithTag:tag];
    textOther.text=value;
}

//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self View_AddTap:nil];
     return YES;
}

- (void)View_AddTap:(id)dateTap
{
    [_labConcent resignFirstResponder];
    
    NSMutableArray *arrayOther=[warnmodel objectForKey:@"InspectTemplateAttributeEntityList"];
    
    if(![[CommonUseClass FormatString:arrayOther] isEqual:@""] )
    {
    for (NSDictionary *dic in arrayOther) {
        int tag=1000+[dic[@"ID"] intValue];
        UITextField *textOther=[self.contentView viewWithTag:tag];
        [textOther resignFirstResponder];
    }
    }
}
- (void)date_select:(UIButton*)btn
{
    [_labConcent resignFirstResponder];
    
    NSMutableArray *arrayOther=[warnmodel objectForKey:@"InspectTemplateAttributeEntityList"];
    if(![[CommonUseClass FormatString:arrayOther] isEqual:@""] )
    {
    for (NSDictionary *dic in arrayOther) {
        int tag=1000+[dic[@"ID"] intValue];
        UITextField *textOther=[self.contentView viewWithTag:tag];
        [textOther resignFirstResponder];
    }
    }
    
    //2.
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",btn.tag],@"textOne",warnmodel[@"StepId"],@"textTwo", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"showDater" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}



#pragma  mark - textField delegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag==2000)
    {
        [warnmodel setValue:textField.text forKey:@"Remark"];
    }
    else
    {
    NSMutableArray *arrayOther=[[warnmodel objectForKey:@"InspectTemplateAttributeEntityList"] mutableCopy];
    NSMutableArray *arrayOtherNew=[NSMutableArray new];
    for (NSDictionary *dicOld in arrayOther) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dicOld];
        int tag=1000+[dic[@"ID"] intValue];
        if(textField.tag ==tag)
        {
            [dic setValue:textField.text forKey:@"InputValue"];
        }
        
//        if([[CommonUseClass FormatString: dic[@"AttributeDescribe"] ] isEqual:@""])
//        {
//            dic[@"AttributeDescribe"]=@"";
//        }
        
        [arrayOtherNew addObject:dic];
    }
        [warnmodel setValue:arrayOtherNew forKey:@"InspectTemplateAttributeEntityList"];
    }
   
}



- (void)setImg_servrerFile{
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPhoto"]] isEqual:@"1"] )
    {
        if([[CommonUseClass FormatString: [warnmodel objectForKey:@"PhotoUrl"]] isEqual:@""])
        {
            _img_serverFile.image=[UIImage imageNamed:@"ic_maintenance_photo1"];
        }
        else
        {
            _img_serverFile.image=[UIImage imageNamed:@"ic_maintenance_photo1sel"];
        }
    }

    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsVideo"]] isEqual:@"1"])
    {
        if([[CommonUseClass FormatString: [warnmodel objectForKey:@"VideoPath"]] isEqual:@""])
        {
            _img_serverFile.image=[UIImage imageNamed:@"ic_maintenance_photo1"];
        }
        else
        {
            _img_serverFile.image=[UIImage imageNamed:@"ic_maintenance_photo1sel"];
        }
    }
    
}
- (void)setImg_thisFile
{
    
    
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPhoto"]] isEqual:@"1"] )
    {
         if(warnmodel[@"have_this_phone"]!=nil
            &&[[CommonUseClass FormatString: warnmodel[@"have_this_phone"]] isEqual:@"1"])
        {
            _img_thisFile.image=[UIImage imageNamed:@"ic_maintenance_photo2sel"];
        }
        else
        {
            _img_thisFile.image=[UIImage imageNamed:@"ic_maintenance_photo2"];
        }
    }
    
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsVideo"]] isEqual:@"1"])
    {
        if([[CommonUseClass FormatString: [warnmodel objectForKey:@"this_video_url"]] isEqual:@""])
        {
            _img_thisFile.image=[UIImage imageNamed:@"ic_maintenance_photo2"];
        }
        else
        {
            _img_thisFile.image=[UIImage imageNamed:@"ic_maintenance_photo2sel"];
        }
    }

    
    
   

}
- (void)setImg_photo{
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsVideo"]] isEqual:@"1"] )
    {
        _img_photo.image=[UIImage imageNamed:@"ic_maintenance_videotape"];
    }
}
//- (void)setImg_lock{
//    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsLock"]] isEqual:@"1"] )
//    {
//        _img_lock.image=[UIImage imageNamed:@"ic_maintenance_locking"];
//        _lab_lock.text=@"已锁定";
//    }
//    else
//    {
//        _img_lock.image=[UIImage imageNamed:@"ic_maintenance_unlock"];
//        _lab_lock.text=@"未锁定";
//    }
//}

- (void)btnclick_serverFile:(UIButton *)sender {
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPhoto"]] isEqual:@"1"] )
    {
        if([[CommonUseClass FormatString: [warnmodel objectForKey:@"PhotoUrl"]] isEqual:@""])
        {
            return;
        }
        else
        {
            [self showImage:[CommonUseClass FormatString: [warnmodel objectForKey:@"PhotoUrl"]]];
        }
    }
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsVideo"]] isEqual:@"1"])
    {
        if([[CommonUseClass FormatString: [warnmodel objectForKey:@"VideoPath"]] isEqual:@""])
        {
            return;
        }
        else
        {
            [self showVideo:[CommonUseClass FormatString: [warnmodel objectForKey:@"VideoPath"]]];
        }
    }
}
- (void)btnclick_thisFile:(UIButton *)sender {
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPhoto"]] isEqual:@"1"] )
    {
        if([warnmodel[@"have_this_phone"] isEqual:@"1"])
        {
            [self showImage_this:warnmodel[@"this_phone"]];
        }
    }
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsVideo"]] isEqual:@"1"])
    {
        NSString *this_video_url=[CommonUseClass FormatString: [warnmodel objectForKey:@"this_video_url"]];
        [self showVideo_this:this_video_url];
    }
}

- (void)btnclick_outLine:(UIButton *)sender {
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPhoto"]] isEqual:@"1"] )
    {
        if([warnmodel[@"have_online_phone"] isEqual:@"1"])
        {
            [self showImage_this:warnmodel[@"online_phone"]];
        }
    }
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsVideo"]] isEqual:@"1"])
    {
        NSString *this_video_url=[CommonUseClass FormatString: [warnmodel objectForKey:@"online_video_url"]];
        [self showVideo_this:this_video_url];
    }
}
- (void)btnclick_photo:(UIButton *)sender {
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPhoto"]] isEqual:@"1"] )
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.view.tag=1000;
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        AVAuthorizationStatus authstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authstatus ==AVAuthorizationStatusRestricted || authstatus ==AVAuthorizationStatusDenied) //用户关闭了权限
        {
            [CommonUseClass showAlter:@"相机权限未开启！"];
            return;
        }
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.sourceType = sourceType;
        
        
        //添加 字典，将label的值通过key值设置传递
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:picker,@"textOne",self,@"textTwo", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"showphoto" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    }
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsVideo"]] isEqual:@"1"]) {
        //录制视频
        [((JYGLSave*)self.delegateCustom) ViewMethod:warnmodel];
    }
    
}

//拍照或选择相册后的编辑图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image;
        image=[info objectForKey:UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:^{

            if (image!=nil) {
               UIImage * imageNew=[self imageAddText:image text:[CommonUseClass getCurrentTimes]];
                
                
                //this_phone=image;
                //have_this_phone=@"1";
                _img_thisFile.image=[UIImage imageNamed:@"ic_maintenance_photo2sel"];
                //2.
                NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:warnmodel];
                [newdic setObject:imageNew forKey:@"this_phone"];
                [newdic setObject:@"1" forKey:@"have_this_phone"];
                [self saveThisValue:newdic];
                
            }
        }];

    }else if ([mediaType isEqualToString:@"public.movie"])
    {

    }
}


/**
 图片合成文字
 
 @param img <#img description#>
 @param logoText <#logoText description#>
 @return <#return value description#>
 */
- (UIImage *)imageAddText:(UIImage *)img text:(NSString *)logoText
{
    NSString* mark = logoText;
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, w, h)];
    NSDictionary *attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:100], NSForegroundColorAttributeName : [UIColor redColor]  };
    //[str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:30.0] range:NSMakeRange(0, 5)];
    
    //位置显示
    [mark drawInRect:CGRectMake(w*0.5, h*0.94, w*0.5, h*0.1) withAttributes:attr];
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return aimg;
    
}




- (void)setFrame:(CGRect)frame
{
    float width=bounds_width.size.width;
    
    frame.size.width = width;
    [super setFrame:frame];
    
}

//save
- (void)dianZanBtn:(UIButton *)sender {
    [self View_AddTap:nil];
    
    if([ [NSString stringWithFormat:@"%f",self.app.Longitude_curr] isEqual:@"0"] )
    {
        [CommonUseClass showAlter:MessageLocation];
        return;
    }
    
    //InspectTemplateAttributeEntityList
    NSMutableArray *arrayOther=[warnmodel objectForKey:@"InspectTemplateAttributeEntityList"];
    if(![[CommonUseClass FormatString:[warnmodel objectForKey:@"InspectTemplateAttributeEntityList"]] isEqual:@""] &&arrayOther.count>0)
    {
        for (NSDictionary *dic in arrayOther) {
            if([[CommonUseClass FormatString: dic[@"InputValue"]] isEqual:@""])
            {
                NSString *str=[NSString stringWithFormat:@"%@不能为空!",dic[@"AttributeName"]];
                [CommonUseClass showAlter:str];
                return;
            }
        }
    }
    
    //1
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPhoto"]] isEqual:@"1"] )
    {
        if (warnmodel[@"have_this_phone"]!=nil
           &&[[CommonUseClass FormatString: warnmodel[@"have_this_phone"]] isEqual:@"1"]) {
            [self thisSaveData:1];
        } else if ([warnmodel [@"IsOutLine"] isEqual:@"1"]) {
            [self thisSaveData:2];
        }  else if (![[CommonUseClass FormatString: [warnmodel objectForKey:@"PhotoUrl"]] isEqual:@""]) {
            [self thisSaveData:3];
        } else {
            [CommonUseClass showAlter:@"请您先拍照！"];
        }
    }
    
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsVideo"]] isEqual:@"1"])
    {
        if([CommonUseClass FormatString: [warnmodel objectForKey:@"this_video_url"]].length>0) {
            [self thisSaveData:1];
        } else if ([warnmodel [@"IsOutLine"] isEqual:@"1"]) {
            [self thisSaveData:2];
        }  else if (![[CommonUseClass FormatString: [warnmodel objectForKey:@"VideoPath"]] isEqual:@""]) {
            [self thisSaveData:3];
        } else {
            [CommonUseClass showAlter:@"请您先录像！"];
        }
    }
}

-(void)deleteThisValue:(NSMutableArray *)array
{
    for (NSDictionary *dic in array) {
        if([dic[@"InspectId"] isEqual: warnmodel[@"InspectId"]]
           &&[[CommonUseClass FormatString: dic[@"StepId"]] isEqual:[CommonUseClass FormatString:warnmodel[@"StepId"]]])
        {
            [array removeObject:dic];
            return;
        }
    }
}

// 1本地 2离线 3服务器
-(void)thisSaveData:(NSInteger)status {
    //1
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array0 = [defaults objectForKey:@"Datajianyan"] ;
    NSMutableArray *array = [array0 mutableCopy];
    
    //2
    if(array==nil) {
        array = [NSMutableArray new];
    }
    [self deleteThisValue:array];
    if (status == 1) {
        [self setLocalData];
    }
    
    //2.2
    NSMutableDictionary *newdic=[NSMutableDictionary new];
    for (NSString *key in warnmodel) {
        if([key isEqual:@"online_phone"]&&[warnmodel[@"have_online_phone"] isEqual:@"1"]) {
            NSData *imageData = UIImageJPEGRepresentation(warnmodel[key],0.5);
            [newdic setObject:imageData forKey:key];
        } else {
            NSString * currV=[CommonUseClass FormatString:warnmodel[key]];
            [newdic setObject:currV forKey:key];
        }
    }
    [newdic setValue:[CommonUseClass FormatString: _labConcent.text] forKey:@"Remark"];
    [newdic setValue:[NSString stringWithFormat:@"%f", self.app.Longitude_curr] forKey:@"MapX"];
    [newdic setValue:[NSString stringWithFormat:@"%f", self.app.Latitude_curr] forKey:@"MapY"];
    [newdic setValue:[CommonUseClass getCurrentTimes] forKey:@"CreateTime"];
    
    NSArray *arraylist=warnmodel[@"InspectTemplateAttributeEntityList"];
    if(![[CommonUseClass FormatString: warnmodel[@"InspectTemplateAttributeEntityList"]] isEqual:@""]&&arraylist.count>0) {
    NSString *strJson=[self toReadableJSONString:warnmodel[@"InspectTemplateAttributeEntityList"]];
     [newdic setValue:strJson forKey:@"TemplateAttributeJson"];
    }
    
    [array addObject:newdic];
    NSArray *myArray = [array copy];
    
    //3
    [defaults setObject:myArray forKey:@"Datajianyan"];
    [defaults synchronize];
    
    [CommonUseClass showAlter:@"离线缓存成功！"];
    //2.
    NSMutableDictionary *newdic2 = [NSMutableDictionary dictionaryWithDictionary:warnmodel];
    [newdic2 setObject:@"1" forKey:@"IsOutLine"];

    [self saveThisValue:newdic2];
    [self showoutLine];
    
}

- (void)setLocalData {
    //2.1
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPhoto"]] isEqual:@"1"] ) {
        [warnmodel setObject:warnmodel[@"this_phone"] forKey:@"online_phone"];
        [warnmodel setObject:warnmodel[@"have_this_phone"] forKey:@"have_online_phone"];
        [warnmodel setObject:@"" forKey:@"this_phone"];
        [warnmodel setObject:@"" forKey:@"have_this_phone"];
    }
    
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsVideo"]] isEqual:@"1"]) {
        [warnmodel setObject:warnmodel[@"this_video_url"] forKey:@"online_video_url"];
        [warnmodel setObject:@"" forKey:@"this_video_url"];
    }
    

}

- (NSString *)toReadableJSONString:(NSArray *)array {
    //2
    NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

-(void)showoutLine{
    if([warnmodel [@"IsOutLine"] isEqual:@"1"])
    {
        _img_outLine.image=[UIImage imageNamed:@"ic_outLine_yes"];
        _img_thisFile.image=[UIImage imageNamed:@"ic_maintenance_photo2"];
    }
}


#pragma mark video
-(void)showVideo:(NSString *)PhotoUrl{
    
    PhotoUrl= [PhotoUrl stringByReplacingOccurrencesOfString:@"~" withString:Ksdby_api_Img];
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:PhotoUrl,@"textOne",@"server",@"textTwo", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"showVideo" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

-(void)showVideo_this:(NSString *)PhotoUrl{
    if([[CommonUseClass FormatString: PhotoUrl] isEqual:@""])return;
    
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"",@"textOne",@"this",@"textTwo",PhotoUrl,@"texturl", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"showVideo" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
#pragma mark 查看大图
-(void)showImage:(NSString *)PhotoUrl{
    
    PhotoUrl= [PhotoUrl stringByReplacingOccurrencesOfString:@"~" withString:Ksdby_api_Img];
    
    
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:PhotoUrl,@"textOne",@"server",@"textTwo", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"showImage" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
   
    
}

-(void)showImage_this:(NSString *)phone{
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:phone,@"textOne",@"this",@"textTwo", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"showImage" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
}



@end
