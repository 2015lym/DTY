//
//  YMTableViewCell.m
//  多张照片选择简单DEMO
//
//  Created by Lym on 16/8/1.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import "YMTableViewCell.h"
#import "TZImagePreviewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>
#import "UIButton+WebCache.h"
#import "WorkUtils.h"

@interface YMTableViewCell()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>

@end

@implementation YMTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"YMTableViewCell";
    YMTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (YMTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(Part_PreviewModel *)model {
    _model = model;
    _dataArray = [NSMutableArray array];
    for (OldImageModel *imgModel in model.images) {
        if ([_titleLabel.text isEqualToString:@"更换部件前照片"] && imgModel.IsBeforeReplacement) {
            [_dataArray addObject:[imgModel yy_modelToJSONObject]];
        }
        if ([_titleLabel.text isEqualToString:@"更换部件后照片"] && !imgModel.IsBeforeReplacement) {
            [_dataArray addObject:[imgModel yy_modelToJSONObject]];
        }
    }
    [self changeUI];
}

/* ---按钮点击事件---*/
- (IBAction)click:(id)sender {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self.viewController presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"模拟无效,请真机测试");
    }
}

//拍照
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *resultImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *imageUrl = [FileFunction saveImage:resultImage];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"ImageUrl"] = imageUrl;
    if ([_titleLabel.text isEqualToString:@"更换部件前照片"]) {
        dic[@"IsBeforeReplacement"] = @"true";
    } else {
        dic[@"IsBeforeReplacement"] = @"false";
    }
    [self.dataArray addObject:dic];
    
    [self changeUI];
}

- (void)changeUI {
    for (UIView *v in [_scrollView subviews]) {
        [v removeFromSuperview];
    }
    
    CGRect workingFrame = _scrollView.frame;
    workingFrame.origin.x = 0;
    workingFrame.origin.y = 0;
    
    for (int i=0; i<_dataArray.count; i++) {
        
        NSDictionary *dic = _dataArray[i];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(workingFrame.origin.x, 10, _photoBtn.frame.size.width, _photoBtn.frame.size.width)];
        btn.tag = 20000 + i;
        if (_isPreview || [dic[@"ImageUrl"] containsString:@"Upload"]) {
            NSString *path = [NSString stringWithFormat:@"%@%@", old_base, dic[@"ImageUrl"]];
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:path] forState:UIControlStateNormal];
        } else {
            NSString *path = [NSString stringWithFormat:@"%@/%@", [FileFunction getSandBoxPath], dic[@"ImageUrl"]];
            [btn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(preview:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        
        if (!_isPreview) {
            UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(workingFrame.origin.x + _photoBtn.frame.size.width - 10, 0, 20, 20)];
            delBtn.tag = 10000 + i;
            [delBtn setBackgroundImage:[UIImage imageNamed:@"老旧电梯-删除"] forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:delBtn];
        }
        
        workingFrame.origin.x = workingFrame.origin.x + _photoBtn.frame.size.width+15;
    }
    
    if (_dataArray.count < 5 && !_isPreview) {
        UIButton *addPhotoBtn=[[UIButton alloc]initWithFrame: CGRectMake(workingFrame.origin.x, 10, _photoBtn.frame.size.width, _photoBtn.frame.size.height)];
        [addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"添加照片"] forState:UIControlStateNormal];
        [addPhotoBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:addPhotoBtn];
        
        workingFrame.origin.x = workingFrame.origin.x + _photoBtn.frame.size.width+15;
    }
    [_scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    [self changeData];
}

- (void)del:(UIButton *)delBtn {
    UIAlertController *Sign=[UIAlertController
                             alertControllerWithTitle:@"确定要删除该项吗？"
                             message:@""
                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *No=[UIAlertAction
                       actionWithTitle:@"取消"
                       style:UIAlertActionStyleDefault
                       handler:nil];
    UIAlertAction *Yes=[UIAlertAction
                        actionWithTitle:@"确定"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * _Nonnull action) {
                            NSDictionary *dic = self.dataArray[delBtn.tag - 10000];
                            NSString *path = [NSString stringWithFormat:@"%@/%@", [FileFunction getSandBoxPath], dic[@"ImageUrl"]];
                            [FileFunction deleteFileAtPath:path];
                            [self.dataArray removeObjectAtIndex:delBtn.tag - 10000];
                            [self changeUI];
                        }];
    [Sign addAction:No];
    [Sign addAction:Yes];
    [self.viewController presentViewController:Sign animated:YES completion:nil];
}

- (void)preview:(UIButton *)btn {
    NSDictionary *dic = self.dataArray[btn.tag - 20000];
    
    
    NSMutableArray *previewArray = [NSMutableArray array];
    if (_isPreview|| [dic[@"ImageUrl"] containsString:@"Upload"]) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", old_base, dic[@"ImageUrl"]];
        NSURL *pathUrl = [NSURL URLWithString:path];
        [previewArray addObject:pathUrl];
    } else {
        NSString *path = [NSString stringWithFormat:@"%@/%@", [FileFunction getSandBoxPath], dic[@"ImageUrl"]];
        [previewArray addObject:[UIImage imageWithContentsOfFile:path]];
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:NO];
    imagePickerVc.showSelectBtn = NO;
    TZImagePreviewController *previewVc = [[TZImagePreviewController alloc] initWithPhotos:previewArray currentIndex:0 tzImagePickerVc:imagePickerVc];
    [previewVc setSetImageWithURLBlock:^(NSURL *URL, UIImageView *imageView, void (^completion)(void)) {
        [self configImageView:imageView URL:URL completion:completion];
    }];
    [self.viewController presentViewController:previewVc animated:YES completion:nil];
}

- (void)configImageView:(UIImageView *)imageView URL:(NSURL *)URL completion:(void (^)(void))completion {
    if ([URL.absoluteString.lowercaseString hasSuffix:@"gif"]) {
        // 先显示静态图占位
        [[SDWebImageManager sharedManager] loadImageWithURL:URL options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (!imageView.image) {
                imageView.image = image;
            }
        }];
        // 动图加载完再覆盖掉
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:URL options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            imageView.image = [UIImage sd_animatedGIFWithData:data];
            if (completion) {
                completion();
            }
        }];
    } else {
        [imageView sd_setImageWithURL:URL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (completion) {
                completion();
            }
        }];
    }
}

/* ---图片大小压缩LYM---*/
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)changeData {
    if ([self.delegate respondsToSelector:@selector(changeData:type:text:)]) {
        if ([_titleLabel.text isEqualToString:@"更换部件前照片"]) {
            [self.delegate changeData:_dataArray type:@"before" text:@""];
        } else {
            [self.delegate changeData:_dataArray type:@"after" text:@""];
        }
    }
}

@end
