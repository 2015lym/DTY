//
//  Old_PartListViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/11.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Old_PartListViewController.h"
#import "Old_PartListTableViewCell.h"

#import "Old_PartDetailViewController.h"

#import "Part_PreviewModel.h"

#import "WorkUtils.h"

@interface Old_PartListViewController ()<Old_PartListTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *cacheArray;

@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *remarkArray;

@end

@implementation Old_PartListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待更换部件";
    if (_isStart) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(submit)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _textField.text = @"";
    [self netRequest];
}

- (IBAction)searchAction:(id)sender {
    if (_textField.text.length == 0) {
        _dataArray = [NSMutableArray arrayWithArray:_cacheArray];
    } else {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (Part_PreviewModel *model in _cacheArray) {
            if ([model.PartName containsString:_textField.text]) {
                [tempArray addObject:model];
            }
        }
        _dataArray = [NSMutableArray arrayWithArray:tempArray];
    }
    [self.tableView reloadData];
}

#pragma mark - ---------- 网络请求 ----------
- (void)netRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TaskId"] = _taskId;
    if (_isStart) {
        dic[@"IsConstructionBegan"] = @"true";
    }
    [self showProgress];
    [NetRequest OLD_POST:reformTask_getElevatorPartRecordByTaskId params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            self.dataArray = [NSMutableArray array];
            for (NSDictionary *dic in [StringFunction stringToJson:baseModel.Data]) {
                Part_PreviewModel *model = [Part_PreviewModel yy_modelWithJSON:dic];
                model.isUnfold = false;
                if ([WorkUtils getImagesArray:self.taskId partId:model.Id].count > 0) {
                    model.localRemark = YES;
                } else if (model.images.count > 0) {
                    model.localRemark = YES;
                    model.netRemark = YES;

                    [WorkUtils saveImages:self.taskId partId:model.Id data:[model.images yy_modelToJSONObject]];
                    [WorkUtils saveRemarks:self.taskId partId:model.Id data:[model.remarks yy_modelToJSONObject]];
                }
                [self.dataArray addObject:model];
            }
            self.cacheArray = [NSMutableArray arrayWithArray:self.dataArray];
            [self.tableView reloadData];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
    }];
}

- (void)submit {
    NSInteger num = 0;
    for (Part_PreviewModel *model in _dataArray) {
        if (!model.localRemark) {
            num = num + 1;
        } else {
            NSMutableArray *beforeArray = [NSMutableArray array];
            NSMutableArray *afterArray = [NSMutableArray array];
            for (NSDictionary *dic in [WorkUtils getAllImagesArray:_taskId]) {
                if ([model.Id isEqualToString:dic[@"GzElevatorPartRecordId"]]) {
                    if ([dic[@"IsBeforeReplacement"] boolValue] == true) {
                        [beforeArray addObject:dic];
                    } else {
                        [afterArray addObject:dic];
                    }
                }
            }
            if (beforeArray.count > 0 && afterArray.count == 0) {
                [self showInfo:[NSString stringWithFormat:@"%@-未填写更换后部件照片", model.PartName]];
                return;
            }
        }
    }
    if (num == _dataArray.count) {
        [self showInfo:@"未填写内容，请填写！"];
        return;
    }
    _imagesArray = [NSMutableArray array];
    _remarkArray = [NSMutableArray array];
    for (NSDictionary *dic in [WorkUtils getAllImagesArray:_taskId]) {
        if (![dic[@"isUpload"] isEqualToString:@"1"] && ![dic[@"ImageUrl"] containsString:@"Upload"]) {
            [self uploadFile:dic type:@"img"];
            return;
        }
    }

    for (NSDictionary *dic in [WorkUtils getAllRemarksArray:_taskId]) {
        if (![dic[@"isUpload"] isEqualToString:@"1"] && ![dic[@"DataType"] isEqualToString:@"text"] && ![dic[@"DataValue"] containsString:@"Upload"]) {
            [self uploadFile:dic type:@"remark"];
            return;
        }
    }

    NSLog(@"上传完了，干别的");
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TaskManageId"] = _taskId;
    dic[@"SaveConstructionCont rastRecordEntityList"] = [WorkUtils getAllImagesArray:_taskId];
    dic[@"SaveConstructionNoteRecordEntityList"] = [WorkUtils getAllRemarksArray:_taskId];
    [self showProgress];
    [NetRequest OLD_POST:reformTask_saveConstructionInfo params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            [self showSuccess:@"提交成功"];
            [WorkUtils clearAllImagesData:self.taskId];
            [WorkUtils clearAllRemarksData:self.taskId];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
    }];
}

- (void)uploadFile:(NSDictionary *)dic type:(NSString *)type {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"filePath"] = @"UploadFile";
    NSData *data;
    NSString *path;
    NSString *mimeType;
    if ([type isEqualToString:@"img"]) {
        path = [NSString stringWithFormat:@"%@/%@", [FileFunction getSandBoxPath], dic[@"ImageUrl"]];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        mimeType = @"image/png";
        data = [BaseFunction getUploadImageData:img];
        params[@"fileName"] = dic[@"ImageUrl"];
    } else {
        params[@"fileName"] = dic[@"DataValue"];
        if ([dic[@"DataType"] isEqualToString:@"img"]) {
            path = [NSString stringWithFormat:@"%@/%@", [FileFunction getSandBoxPath], dic[@"DataValue"]];
            mimeType = @"image/png";
            data = [NSData dataWithContentsOfFile:path];
        } else if ([dic[@"DataType"] isEqualToString:@"audio"]) {
            path = [NSString stringWithFormat:@"%@/%@", [FileFunction getSandBoxPath],  dic[@"DataValue"]];
            data = [NSData dataWithContentsOfFile:path];
            mimeType = @"audio/aac";
        } else if ([dic[@"DataType"] isEqualToString:@"video"]) {
            path = [NSString stringWithFormat:@"%@/video/%@", [FileFunction getSandBoxPath], dic[@"DataValue"]];
            data = [NSData dataWithContentsOfFile:path];
            mimeType = @"video/mp4";
        } else {
            [self submit];
        }
    }
    
    [self showProgress];
    
    
    [NetRequest OLD_uploadFile:account_uploadFile params:params fileData:data mimeType:mimeType callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            NSString *newUrl = [NSString stringWithFormat:@"%@", baseModel.Data];
            if ([type isEqualToString:@"img"]) {
                [WorkUtils updateImagesUrl:self.taskId partId:dic[@"GzElevatorPartRecordId"] oldUrl:dic[@"ImageUrl"] url:newUrl];
            } else {
                [WorkUtils updateRemarksUrl:self.taskId partId:dic[@"GzElevatorPartRecordId"] oldUrl:dic[@"DataValue"] url:newUrl];
            }
            BOOL isDel = [FileFunction deleteFileAtPath:path];
            NSLog(@"本地文件删除：%d", isDel);
            [self submit];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self showInfo:@"上传文件失败"];
    }];
}

#pragma mark - ---------- Section的数量 ----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Part_PreviewModel *model = _dataArray[indexPath.row];
    if (model.isUnfold) {
        NSMutableArray *valueArray = [NSMutableArray arrayWithArray:model.entityArray];
        for (BindPartModel *part in model.parts) {
            PartAttributeEntityListModel *e1 = [PartAttributeEntityListModel new];
            e1.PartAttributeName = @"部件编码";
            e1.PartAttributeValue = part.ProductNumber;
            [valueArray addObject:e1];
            PartAttributeEntityListModel *e2 = [PartAttributeEntityListModel new];
            if (part.QRCode.length > 0) {
                e2.PartAttributeName = @"激光二维码";
                e2.PartAttributeValue = part.QRCode;
                
            } else {
                e2.PartAttributeName = @"nfc编码";
                e2.PartAttributeValue = part.NfcNumber;
            }
            [valueArray addObject:e2];
            if (part.QRCode.length > 0 && part.NfcNumber.length > 0) {
                PartAttributeEntityListModel *e3 = [PartAttributeEntityListModel new];
                e3.PartAttributeName = @"nfc编码";
                e3.PartAttributeValue = part.NfcNumber;
                [valueArray addObject:e3];
            }
        }
        PartAttributeEntityListModel *pp = [PartAttributeEntityListModel new];
        pp.PartAttributeName = @"备注/零件";
        pp.PartAttributeValue = model.RemarksParts;
        [valueArray addObject:pp];
        return 51 + 8 + valueArray.count*8 + valueArray.count*14.5 + 15;
    } else {
        return 51;
    }
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Old_PartListTableViewCell *cell = [Old_PartListTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.isPreview = !_isStart;
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (void)unfoldAction:(BOOL)isUnfold andIndex:(NSIndexPath *)indexPath {
    Part_PreviewModel *model = _dataArray[indexPath.row];
    model.isUnfold = isUnfold;
    _dataArray[indexPath.row] = model;
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)clearActionIndex:(NSIndexPath *)indexPath {
    [self showAlertController:@"确定清空填写的内容吗？" callBack:^{
        Part_PreviewModel *model = self.dataArray[indexPath.row];
        [WorkUtils removeImagesData:self.taskId partId:model.Id];
        [WorkUtils removeRemarksData:self.taskId partId:model.Id];
        model.localRemark = NO;
        self.dataArray[indexPath.row] = model;
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }];
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Part_PreviewModel *model = _dataArray[indexPath.row];
    Old_PartDetailViewController *vc = [Old_PartDetailViewController new];
    vc.model = model;
    vc.taskId = _taskId;
    vc.isPreview = !_isStart;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
