//
//  Old_RemarkTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/19.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Old_RemarkTableViewCell.h"
#import "UITextView+ZWPlaceHolder.h"
#import "UITextView+ZWLimitCounter.h"
#import "XFCameraController.h"
#import "TZImagePreviewController.h"
#import "VoiceMarkViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>
#import "UIButton+WebCache.h"
#import "WorkUtils.h"
#import "SVProgressHUD.h"

@interface Old_RemarkTableViewCell()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate, VoiceMarkViewControllerDelegate, UITextViewDelegate>

@end

@implementation Old_RemarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textView.zw_placeHolder = @"请输入文字";
    _textView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Old_RemarkTableViewCell";
    Old_RemarkTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Old_RemarkTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}


- (void)setModel:(Part_PreviewModel *)model {
    _model = model;
    _dataArray = [NSMutableArray array];
    for (OldRemarkModel *rmkModel in model.remarks) {
        if ([rmkModel.DataType isEqualToString:@"text"]) {
            _textView.text = rmkModel.DataValue;
        } else {
            [_dataArray addObject:[rmkModel yy_modelToJSONObject]];
        }
    }
    _textView.editable = NO;
    _toolBar.hidden = YES;
    [self changeUI];
}

- (BOOL)checkNumber {
    if (_textView.text.length == 0 && _dataArray.count > 10) {
        [SVProgressHUD showInfoWithStatus:@"图片、视频、语音总数量不能超过10个！"];
        [SVProgressHUD dismissWithDelay:1];
        return NO;
    } else if (_textView.text.length > 0 && _dataArray.count > 11) {
        [SVProgressHUD showInfoWithStatus:@"图片、视频、语音总数量不能超过10个！"];
        [SVProgressHUD dismissWithDelay:1];
        return NO;
    } else {
        return YES;
    }
}

- (IBAction)takePhoto:(id)sender {
    if ([self checkNumber]) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从手机选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了从手机选择");
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            imagePickerVc.allowPickingVideo = NO;
            [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        //把action添加到actionSheet里
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [actionSheet addAction:action3];
        //相当于之前的[actionSheet show];
        [self.viewController presentViewController:actionSheet animated:YES completion:nil];
    }
}

// 相册
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    UIImage *resultImage = photos.firstObject;
    NSString *imageName = [FileFunction saveImage:resultImage];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"DataValue"] = imageName;
    dic[@"DataType"] = @"img";
    [_dataArray addObject:dic];
    [self changeUI];
}


//拍照
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *resultImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *imageName = [FileFunction saveImage:resultImage];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"DataValue"] = imageName;
    dic[@"DataType"] = @"img";
    [_dataArray addObject:dic];
    [self changeUI];
}

- (IBAction)takeVoice:(id)sender {
    if ([self checkNumber]) {
        VoiceMarkViewController *vc = [VoiceMarkViewController new];
        vc.delegate = self;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)voicePath:(NSString *)fileName {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"DataValue"] = fileName;
    dic[@"DataType"] = @"audio";
    [_dataArray addObject:dic];
    [self changeUI];
}


- (IBAction)takeVideo:(id)sender {
    if ([self checkNumber]) {
        XFCameraController *cameraController = [XFCameraController defaultCameraController];
        __weak XFCameraController *weakCameraController = cameraController;
        cameraController.shootCompletionBlock = ^(NSURL *videoUrl, CGFloat videoTimeLength, UIImage *thumbnailImage, NSError *error) {
            NSLog(@"%@", videoUrl);
            [weakCameraController dismissViewControllerAnimated:YES completion:nil];
            
            NSString *fileUrl = [videoUrl.absoluteString componentsSeparatedByString:@"/"].lastObject;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"DataValue"] = fileUrl;
            dic[@"DataType"] = @"video";
            [self.dataArray addObject:dic];
            [self changeUI];
        };
        [self.viewController presentViewController:cameraController animated:YES completion:nil];
    }
}

- (void)changeUI {
    
    CGFloat height = _scrollBackView.frame.size.height - 30;
    
    for (UIView *v in [_scrollView subviews]) {
        [v removeFromSuperview];
    }
    
    CGRect workingFrame = _scrollView.frame;
    workingFrame.origin.x = 15;
    workingFrame.origin.y = 0;
    
    for (int i=0; i<_dataArray.count; i++) {
        NSDictionary *dic = _dataArray[i];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(workingFrame.origin.x, 10, height, height)];
        btn.tag = 20000 + i;
        if ([dic[@"DataType"] isEqualToString:@"img"]) {
            if (_isPreview || [dic[@"DataValue"] containsString:@"Upload"]) {
                NSString *path = [NSString stringWithFormat:@"%@%@", old_base, dic[@"DataValue"]];
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:path] forState:UIControlStateNormal];
            } else {
                NSString *path = [NSString stringWithFormat:@"%@/%@", [FileFunction getSandBoxPath], dic[@"DataValue"]];
                [btn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
            }

        } else if ([dic[@"DataType"] isEqualToString:@"video"]) {
            [btn setBackgroundImage:[UIImage imageNamed:@"老旧电梯-视频"] forState:UIControlStateNormal];
        } else {
            [btn setBackgroundImage:[UIImage imageNamed:@"老旧电梯-语音"] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(preview:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        
        if (!_isPreview) {
            UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(workingFrame.origin.x + height - 10, 0, 20, 20)];
            delBtn.tag = 10000 + i;
            [delBtn setBackgroundImage:[UIImage imageNamed:@"老旧电梯-删除"] forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:delBtn];
        }
        
        workingFrame.origin.x = workingFrame.origin.x + height+15;
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
                            NSLog(@"%ld", delBtn.tag);
                            NSDictionary *dic = self.dataArray[delBtn.tag - 10000];
                            NSString *path;
                            if ([dic[@"DataType"] isEqualToString:@"video"]) {
                                path = [NSString stringWithFormat:@"%@/video/%@", [FileFunction getSandBoxPath], dic[@"DataValue"]];
                            } else {
                                path = [NSString stringWithFormat:@"%@/%@", [FileFunction getSandBoxPath], dic[@"DataValue"]];
                            }
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
    
    if ([dic[@"DataType"] isEqualToString:@"img"]) {
        NSMutableArray *previewArray = [NSMutableArray array];
        if (_isPreview ||  [dic[@"DataValue"] containsString:@"Upload"]) {
            NSString *path = [NSString stringWithFormat:@"%@/%@", old_base, dic[@"DataValue"]];
            NSURL *pathUrl = [NSURL URLWithString:path];
            [previewArray addObject:pathUrl];
        } else {
            NSString *path = [NSString stringWithFormat:@"%@/%@", [FileFunction getSandBoxPath], dic[@"DataValue"]];
            [previewArray addObject:[UIImage imageWithContentsOfFile:path]];
        }

        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:NO];
        imagePickerVc.showSelectBtn = NO;
        TZImagePreviewController *previewVc = [[TZImagePreviewController alloc] initWithPhotos:previewArray currentIndex:0 tzImagePickerVc:imagePickerVc];
        [previewVc setSetImageWithURLBlock:^(NSURL *URL, UIImageView *imageView, void (^completion)(void)) {
            [self configImageView:imageView URL:URL completion:completion];
        }];
        [self.viewController presentViewController:previewVc animated:YES completion:nil];
    } else if ([dic[@"DataType"] isEqualToString:@"video"]) {
        NSMutableArray *previewArray = [NSMutableArray array];
        NSString *path;
        
        if (_isPreview || [dic[@"DataValue"] containsString:@"Upload"]) {
            path = [NSString stringWithFormat:@"%@%@", old_base, dic[@"DataValue"]];
        } else {
            path = [NSString stringWithFormat:@"%@/video/%@", [FileFunction getSandBoxPath], dic[@"DataValue"]];
        }
        
        NSURL *pathUrl = [NSURL fileURLWithPath:path];
        [previewArray addObject:pathUrl];
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:NO];
        imagePickerVc.showSelectBtn = NO;
        TZImagePreviewController *previewVc = [[TZImagePreviewController alloc] initWithPhotos:previewArray currentIndex:0 tzImagePickerVc:imagePickerVc];
        [self.viewController presentViewController:previewVc animated:YES completion:nil];
    } else {
        VoiceMarkViewController *vc = [VoiceMarkViewController new];
        vc.isPreview = YES;
        vc.delegate = self;
        vc.isUpload = _isPreview;
        if ([dic[@"DataValue"] containsString:@"Upload"]) {
            vc.isUpload = YES;
            vc.fileName = [NSString stringWithFormat:@"%@%@", old_base, dic[@"DataValue"]];
        } else {
            vc.fileName = dic[@"DataValue"];
        }
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
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

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(changeData:type:text:)]) {
        [self.delegate changeData:_dataArray type:@"text" text:textView.text];
    }
}

- (void)changeData {
    if ([self.delegate respondsToSelector:@selector(changeData:type:text:)]) {
        [self.delegate changeData:_dataArray type:@"remark" text:@""];
    }
}
@end
