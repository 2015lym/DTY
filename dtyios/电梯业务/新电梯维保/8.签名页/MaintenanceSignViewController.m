//
//  MaintenanceSignViewController.m
//  dtyios
//
//  Created by Lym on 2020/6/26.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceSignViewController.h"
#import "BJTSignView.h"
#import "TZImagePreviewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MaintenanceSignViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic,strong) BJTSignView *signView;
@property (nonatomic, strong) UserModel *model;
@end

@implementation MaintenanceSignViewController

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
    
    _model = [UserService getUserInfo];
    
    self.signView = [[BJTSignView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, (SCREEN_WIDTH-30)*2/3)];
    [_backView addSubview:self.signView];
    
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(saveSignImage)];
    UIBarButtonItem *rightButton2 = [[UIBarButtonItem alloc] initWithTitle:@"清除"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(clearSignImage)];
    self.navigationItem.rightBarButtonItems = @[rightButton1, rightButton2];
    
}

// 保存图片
- (void)saveSignImage {
    if (self.signView.hasImage) {
        if (_isCheck) {
            [self uploadFile2:[self.signView getSignatureImage]];
        } else {
            [self uploadFile:[self.signView getSignatureImage]];
        }
    } else {
        [self showInfo:@"请填写签名！"];
    }
}

// 清除图片
- (void)clearSignImage {
    [self.signView clearSignature];
}

// 提交
- (void)uploadFile:(UIImage *)image {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"filePath"] = @"UploadFile";
    NSData *data= [BaseFunction getUploadImageData:image];
    NSString *mimeType = @"image/png";
    params[@"fileName"] = @"sign.png";
    
    [self showProgress];
    [NetRequest uploadFile:@"NPMaintenanceApp/SaveUserSign" params:params fileData:data mimeType:mimeType callback:^(BaseModel *uploadModel) {
//        [UserService setUserInfo:self.model];
        if (uploadModel.success) {
            self.photoUrl = [NSString stringWithFormat:@"%@", uploadModel.data];
            [self submit];
        } else {
            [self showInfo:uploadModel.Message];
        }
    } errorCallback:^(NSError *error) {
         [self hideProgress];
    }];
}

- (void)submit {
    
    for (int i=0; i<_maintenanceModel.itemArray.count; i++) {
        AppMaintenanceItemDtos *item = _maintenanceModel.itemArray[i];
        for (int j=0; j<item.photos.count; j++) {
            AppMaintenanceWorkRecordImgDtos *photo = item.photos[j];
            if (![photo.ImgUrl containsString:@"Upload"]) {
                [self uploadImage:photo atNum1:i atNum2:j];
                return;
            }
        }
    }

    NSLog(@"上传完了，干别的");
    
    self.maintenanceModel.userSign.UserId = [UserService getUserInfo].userId;
    self.maintenanceModel.UserId = [UserService getUserInfo].userId;
    self.maintenanceModel.userSign.UserSign = self.photoUrl;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.maintenanceModel yy_modelToJSONObject]];
    dic[@"userId"] = [UserService getUserInfo].userId;
    
    [NetRequest POST:@"NPMaintenanceApp/SaveMaintenanceWorkOrder" params:dic callback:^(BaseModel *baseModel) {
        if (baseModel.success) {
            [self showSuccess:@"提交成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self showInfo:@"服务器错误"];
    }];
}

// 审核提交
- (void)uploadFile2:(UIImage *)image {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"filePath"] = @"UploadFile";
    NSData *data= [BaseFunction getUploadImageData:image];
    NSString *mimeType = @"image/png";
    params[@"fileName"] = @"sign.png";
    
    [self showProgress];
    [NetRequest uploadFile:@"NPMaintenanceApp/SaveUserSign" params:params fileData:data mimeType:mimeType callback:^(BaseModel *uploadModel) {

        if (uploadModel.success) {
            NSString *newUrl = [NSString stringWithFormat:@"%@", uploadModel.data];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"userId"] = [UserService getUserInfo].userId;
            dic[@"UserId"] = [UserService getUserInfo].userId;
            dic[@"WorkOrderId"] = self.workOrderId;
            dic[@"SignImgUrl"] = newUrl;
            [NetRequest POST:@"NPMaintenanceApp/SaveMaintenanceWorkOrderAudit" params:dic callback:^(BaseModel *baseModel) {
                if (baseModel.success) {
                    [self showSuccess:@"提交成功"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [self showInfo:baseModel.Message];
                }
                [self hideProgress];
            } errorCallback:^(NSError *error) {
                [self hideProgress];
                [self showInfo:@"服务器错误"];
            }];
        } else {
            [self showInfo:uploadModel.Message];
        }
    } errorCallback:^(NSError *error) {
         [self hideProgress];
    }];
}


- (void)uploadImage:(AppMaintenanceWorkRecordImgDtos *)photo atNum1:(int )i atNum2:(int)j {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"filePath"] = @"UploadFile";
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [FileFunction getSandBoxPath], photo.ImgUrl];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    NSString *mimeType = @"image/png";
    NSData *data = [BaseFunction getUploadImageData:img];
    params[@"fileName"] = photo.ImgUrl;
    
    [self showProgress];
    [NetRequest uploadFile:@"NPMaintenanceApp/SaveMaintenanceImg" params:params fileData:data mimeType:mimeType callback:^(BaseModel *uploadModel) {
        if (uploadModel.success) {
            NSString *newUrl = [NSString stringWithFormat:@"%@", uploadModel.data];
            self.maintenanceModel.itemArray[i].photos[j].ImgUrl = newUrl;
            BOOL isDel = [FileFunction deleteFileAtPath:path];
            NSLog(@"本地文件删除：%d", isDel);
            [self submit];
        } else {
            [self showInfo:uploadModel.Message];
        }
    } errorCallback:^(NSError *error) {
        [self hideProgress];
    }];
    
}
@end
