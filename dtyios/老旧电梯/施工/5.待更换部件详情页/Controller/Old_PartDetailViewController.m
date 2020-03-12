//
//  Old_PartDetailViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/19.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Old_PartDetailViewController.h"

#import "Old_PartPreviewTableViewCell.h"
#import "YMTableViewCell.h"
#import "Old_RemarkTableViewCell.h"

#import "WorkUtils.h"

@interface Old_PartDetailViewController ()<RemarkDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YMTableViewCell *beforeCell;
@property (nonatomic, strong) YMTableViewCell *afterCell;
@property (nonatomic, strong) Old_RemarkTableViewCell *remarkCell;

@property (nonatomic, strong) NSMutableArray *beforeArray;
@property (nonatomic, strong) NSMutableArray *afterArray;
@property (nonatomic, strong) NSMutableArray *remarkArray;
@property (nonatomic, copy) NSString *remarkString;


@end

@implementation Old_PartDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _model.PartName;
    if (!_isPreview) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(save)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    
    _beforeArray = [NSMutableArray array];
    _afterArray = [NSMutableArray array];
    _remarkArray = [NSMutableArray array];

    for (NSDictionary *dic in [WorkUtils getImagesArray:_taskId partId:_model.Id]) {
        NSString *before = [NSString stringWithFormat:@"%@", dic[@"IsBeforeReplacement"]];
        if ([before isEqualToString:@"true"] || [before isEqualToString:@"1"]) {
            [_beforeArray addObject:dic];
        } else {
            [_afterArray addObject:dic];
        }
    }
    
    for (NSDictionary *dic in [WorkUtils getRemarksArray:_taskId partId:_model.Id]) {
        if (![dic[@"DataType"] isEqualToString:@"text"]) {
            [_remarkArray addObject:dic];
        } else {
            _remarkString = dic[@"DataValue"];
        }
    }
}

- (void)save {
    if (_beforeArray.count < 1) {
        [self showInfo:@"请至少上传1张更换部件前照片！"];
        return;
    } else {
        NSMutableArray *imgsArray = [NSMutableArray array];
        for (NSDictionary *dic in _beforeArray) {
            NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            mdic[@"TaskManageId"] = _taskId;
            mdic[@"GzElevatorPartRecordId"] = _model.Id;
            [imgsArray addObject:mdic];
        }
        for (NSDictionary *dic in _afterArray) {
            NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            mdic[@"TaskManageId"] = _taskId;
            mdic[@"GzElevatorPartRecordId"] = _model.Id;
            [imgsArray addObject:mdic];
        }
        [WorkUtils saveImages:_taskId partId:_model.Id data:imgsArray];
        
        
        NSMutableArray *remarksArray = [NSMutableArray array];
        for (NSDictionary *dic in _remarkArray) {
            NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            mdic[@"TaskManageId"] = _taskId;
            mdic[@"GzElevatorPartRecordId"] = _model.Id;
            [remarksArray addObject:mdic];
        }
        
        if (_remarkString > 0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"TaskManageId"] = _taskId;
            dic[@"GzElevatorPartRecordId"] = _model.Id;
            dic[@"DataValue"] = _remarkString;
            dic[@"DataType"] = @"text";
            [remarksArray addObject:dic];
        }
        [WorkUtils saveRemarks:_taskId partId:_model.Id data:remarksArray];
        [self showInfo:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ---------- 每个Section的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSMutableArray *valueArray = [NSMutableArray arrayWithArray:_model.entityArray];
        for (BindPartModel *part in _model.parts) {
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
        return 15 + 21 + 8 + valueArray.count*8 + valueArray.count*14.5 + 15;
    } else if (indexPath.row == 1) {
        return 44;
    } else if (indexPath.row == 4) {
        return 400;
    } else {
        return 150;
    }
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        Old_PartPreviewTableViewCell *cell = [Old_PartPreviewTableViewCell cellWithTableView:tableView];
        cell.model = _model;
        cell.titleLabel.text = @"部件信息";
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *ideitifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideitifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"备注/零件：%@", _model.RemarksParts];
        return cell;
    } else if (indexPath.row == 2) {
        _beforeCell = [YMTableViewCell cellWithTableView:tableView];
        _beforeCell.titleLabel.text = @"更换部件前照片";
        _beforeCell.isPreview = _isPreview;
        _beforeCell.model = _model;
        if (!_isPreview) {
            _beforeCell.delegate = self;
            _beforeCell.dataArray = _beforeArray;
            [_beforeCell changeUI];
        }
        return _beforeCell;
    } else if (indexPath.row == 3) {
        _afterCell = [YMTableViewCell cellWithTableView:tableView];
        _afterCell.titleLabel.text = @"更换部件后照片";
        _afterCell.isPreview = _isPreview;
        _afterCell.model = _model;
        if (!_isPreview) {
            _afterCell.delegate = self;
            _afterCell.dataArray = _afterArray;
            [_afterCell changeUI];
        }
        return _afterCell;
    } else {
        _remarkCell = [Old_RemarkTableViewCell cellWithTableView:tableView];
        
        _remarkCell.isPreview = _isPreview;
        _remarkCell.model = _model;
        if (!_isPreview) {
            _remarkCell.delegate = self;
            _remarkCell.dataArray = _remarkArray;
            _remarkCell.textView.text = _remarkString;
            _remarkCell.toolBar.hidden = NO;
            _remarkCell.textView.editable = YES;
            [_remarkCell changeUI];
        }
        return _remarkCell;
    }
}

- (void)changeData:(NSMutableArray *)array type:(NSString *)type text:(NSString *)text {
    if ([type isEqualToString:@"before"]) {
        _beforeArray = array;
    } else if ([type isEqualToString:@"after"]) {
        _afterArray = array;
    } else if ([type isEqualToString:@"remark"]) {
        _remarkArray = array;
    } else {
        _remarkString = text;
    }
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
