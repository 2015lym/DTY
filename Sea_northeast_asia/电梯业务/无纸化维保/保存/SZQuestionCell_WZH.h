//
//  SZQuestionCell_WZH.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/7/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyControl.h"
#import "CommonUseClass.h"
#import "NFCSBNewViewController.h"
@class SZConfigure;
@import CoreNFC;
#define BUTTON_WIDTH 30
#define HEADER_MARGIN 10
#define OPTION_MARGIN 20
#define OPEN_OPTION_CELL_H 44
#define WIDTH (self.frame.size.width)
#define HEIGHT (self.frame.size.height)

typedef void(^selectOptionBack)(NSInteger index, NSDictionary *dict);


typedef void(^selectTextFiledBack)(NSInteger index, NSString *text);
typedef void(^selectNFCBack)(NSInteger index, NSString *text);

@class SZQuestionCell;
@protocol ShopsCellDelegate <NSObject>
@optional
-(void)attentionButtonClick:(UIButton*)sender clickedWithData:(NSString *)celldata clickedWithPhoto:(NSString *)photo;
@end




@interface SZQuestionCell_WZH : UITableViewCell<UITextFieldDelegate>
{NSString *guid;
   
}
@property (nonatomic, weak) id<UITableViewExViewDelegate> delegateCustom;
@property (nonatomic, strong)UITextView *textField1;
 @property (nonatomic, strong) UIView *view_Nfc;
 @property (nonatomic, strong) UIImageView *img_head33;
@property (nonatomic, copy) selectOptionBack selectOptionBack;


@property (nonatomic, copy) selectTextFiledBack selecttextfieldBack;
@property (nonatomic, copy) selectNFCBack selectNFCBack;

@property (weak, nonatomic) NSString *typeStr;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDict:(NSDictionary *)contentDict andQuestionNum:(NSInteger)questionNum andWidth:(CGFloat)width andConfigure:(SZConfigure *)configure forIsNfc:(NSArray * )IsNFCOKArr;


@property (weak, nonatomic) id <ShopsCellDelegate> delegate;




@end
