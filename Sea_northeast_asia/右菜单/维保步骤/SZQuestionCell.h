//
//  SZQuestionCell.h
//  SZQuestionCheckBox_demo
//
//  Created by 吴三忠 on 16/4/28.
//  Copyright © 2016年 吴三忠. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZConfigure;

#define BUTTON_WIDTH 30
#define HEADER_MARGIN 10
#define OPTION_MARGIN 20
#define OPEN_OPTION_CELL_H 44
#define WIDTH (self.frame.size.width)
#define HEIGHT (self.frame.size.height)

typedef void(^selectOptionBack)(NSInteger index, NSDictionary *dict);


typedef void(^selectTextFiledBack)(NSInteger index, NSString *text);

@class SZQuestionCell;
@protocol ShopsCellDelegate <NSObject>
@optional
-(void)attentionButtonClick:(UIButton*)sender clickedWithData:(NSString *)celldata clickedWithPhoto:(NSString *)photo;
@end

@interface SZQuestionCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong)UITextView *textField1;

@property (nonatomic, copy) selectOptionBack selectOptionBack;


@property (nonatomic, copy) selectTextFiledBack selecttextfieldBack;

@property (weak, nonatomic) NSString *typeStr;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDict:(NSDictionary *)contentDict andQuestionNum:(NSInteger)questionNum andWidth:(CGFloat)width andConfigure:(SZConfigure *)configure;


@property (weak, nonatomic) id <ShopsCellDelegate> delegate;



@end
