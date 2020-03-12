//
//  SignViewController.m
//  ElevatorRemodelApp
//
//  Created by Lym on 2019/5/8.
//  Copyright © 2019 sinodom. All rights reserved.
//

#import "SignViewController.h"
#import "BJTSignView.h"
#import "TZImagePreviewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SignViewController ()<UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;
@property(nonatomic,strong) BJTSignView *signView;

@property (nonatomic, strong) OldUserModel *model;
@end

@implementation SignViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"电子签名";
    
    _model = [UserService getOldUserInfo];
    
    self.signView = [[BJTSignView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, (SCREEN_WIDTH-30)*2/3)];
    [_backView addSubview:self.signView];
    
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(saveSignImage)];
    UIBarButtonItem *rightButton2 = [[UIBarButtonItem alloc] initWithTitle:@"清除"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(clearSignImage)];
    self.navigationItem.rightBarButtonItems = @[rightButton1, rightButton2];
    if (_model.UserSign.length > 0) {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@", old_base, _model.UserSign];
        NSURL *pathUrl = [NSURL URLWithString:urlString];
        [_signImageView sd_setImageWithURL:pathUrl];
    }
    
    if (_signImageView.image) {
        //单击的手势
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkImageView)];
        [_signImageView addGestureRecognizer:tapRecognizer];
    }
}

// 保存图片
- (void)saveSignImage {
    if (self.signView.hasImage) {
        [self uploadFile:[self.signView getSignatureImage]];
    } else {
        [self showInfo:@"请填写签名！"];
    }
}

// 清除图片
- (void)clearSignImage {
    [self.signView clearSignature];
}

// 查看大图
- (void)checkImageView {
    NSString *path = [NSString stringWithFormat:@"%@/Image/SIGN_IMAGE.png", [FileFunction getSandBoxPath]];
    NSMutableArray *previewArray = [NSMutableArray array];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    [previewArray addObject:img];

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:NO];
    imagePickerVc.showSelectBtn = NO;
    TZImagePreviewController *previewVc = [[TZImagePreviewController alloc] initWithPhotos:previewArray currentIndex:0 tzImagePickerVc:imagePickerVc];
    [self presentViewController:previewVc animated:YES completion:nil];
}

- (void)uploadFile:(UIImage *)image {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"filePath"] = @"UploadFile";
    NSData *data= [BaseFunction getUploadImageData:image];
    NSString *mimeType = @"image/png";
    params[@"fileName"] = @"sign.png";
    
    [self showProgress];

    [NetRequest OLD_uploadFile:account_uploadFile params:params fileData:data mimeType:mimeType callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            NSString *newUrl = [NSString stringWithFormat:@"%@", baseModel.Data];
            
            self.model.UserSign = newUrl;
            [UserService setOldUserInfo:self.model];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"FilePath"] = newUrl;
            dic[@"Account"] = [UserService getOldUserInfo].Account;
            [self showProgress];
            [NetRequest OLD_POST:account_updateUserSign params:dic callback:^(OldElevatorBaseModel *baseModel) {
                if (baseModel.Success) {
                    [self showSuccess:@"签名保存成功！"];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [self showInfo:baseModel.Message];
                }
                [self hideProgress];
            } errorCallback:^(NSError *error) {
                [self hideProgress];
            }];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self showInfo:@"上传文件失败"];
    }];
}
@end
