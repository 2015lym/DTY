//
//  MaintenanceOrderDetailViewController.m
//  dtyios
//
//  Created by Lym on 2020/6/11.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceOrderDetailViewController.h"
#import "MaintenanceRefuseOrderViewController.h"
#import "MapTableViewCell.h"
#import "SignTableViewCell.h"
#import "MaintenanceRecordModel.h"

#import "MaintenanceQRCodeViewController.h"
#import "MaintenanceContentViewController.h"
#import "MaintenanceAuditContentViewController.h"

@interface MaintenanceOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
//@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) MaintenanceRecordModel *model;

@end

@implementation MaintenanceOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = [NSMutableArray arrayWithObjects:@"注册代码", @"项目名称", @"内部编号", @"维保类别", @"维保人员", @"维保到期时间", @"联系方式", @"使用单位", @"维保单位", nil];
//    _dataArray = [NSMutableArray arrayWithObjects:@"310173678463383838", @"左岸经典小区", @"8#东", @"半月维保", @"张三、李四", @"2020-06-11", @"1398748473", @"左岸经典物业服务有限公司", @"日立电梯(中国)有限公司", nil];
    [self setPageOrderType];
    [self netRequest];
}

- (void)netRequest {
    [self showProgress];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [UserService getUserInfo].userId;
    dic[@"workOrderId"] = _workOrderId;
    [NetRequest GET:@"NPMaintenanceApp/GetMaintenanceWorkOrders" params:dic callback:^(BaseModel *baseModel) {
        if (baseModel.success) {
            self.model = [MaintenanceRecordModel yy_modelWithJSON:baseModel.data];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self.tableView reloadData];
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self showInfo:@"服务器错误"];
    }];
}

#pragma mark - ---------- 每个Section的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

#pragma mark - ---------- Section的数量 ----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _titleArray.count) {
        return 250;
    } else if (indexPath.row == _titleArray.count + 1) {
        return 250;
    } else if (indexPath.row == _titleArray.count + 2) {
        return 250;
    } else {
        return 44;
    }
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_model.SupervisorSignImgUrl.length > 0) {
        if (_model.SignImgUrl.length > 0) {
            return _titleArray.count + 3;
        } else {
            return _titleArray.count + 2;
        }
    } else {
        return _titleArray.count + 1;
    }
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _titleArray.count) {
        MapTableViewCell *cell = [MapTableViewCell cellWithTableView:tableView];
        return cell;
    } else if (indexPath.row > _titleArray.count) {
        SignTableViewCell *cell = [SignTableViewCell cellWithTableView:tableView];
        if (indexPath.row == _titleArray.count + 1) {
            cell.titleLabel.text = @"主管签字";
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Ksdby_api_Img, _model.SupervisorSignImgUrl]];
            [cell.signImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"占位图"]];
        } else {
            cell.titleLabel.text = @"物业签字";
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Ksdby_api_Img, _model.SignImgUrl]];
            [cell.signImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"占位图"]];
        }
        return cell;
    } else {
        static NSString *ideitifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideitifier];
        }
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.detailTextLabel.text = [self getItemFromIndex:indexPath.row];
        return cell;
    }
}

- (NSString *)getItemFromIndex:(NSInteger )index {
    if (_model) {
        NSMutableString *peopleList = [[NSMutableString alloc] init];
        NSMutableString *mobileList = [[NSMutableString alloc] init];
        for (NSDictionary *dic in _model.MaintenanceUserNameList) {
            [peopleList appendString:dic[@"MaintenanceUserName"]];
            [peopleList appendString:@"、"];
            [mobileList appendString:dic[@"Mobile"]];
            [mobileList appendString:@"、"];
        }
        if (index == 0) {
            return _model.CertificateNum;
        } else if (index == 1) {
            return _model.ParkName;
        } else if (index == 2) {
            return _model.AddressPath;
        } else if (index == 3) {
            return _model.TypeName;
        } else if (index == 4) {
            return [peopleList substringToIndex:peopleList.length - 1];
        } else if (index == 5) {
            return [_model.PlanMaintenanceTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        } else if (index == 6) {
            return [mobileList substringToIndex:mobileList.length - 1];
        } else if (index == 7) {
            return _model.UseDeptName;
        } else if (index == 8) {
            return _model.MaintDeptName;
        } else {
            return @"";
        }
    } else {
        return @"";
    }
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setPageOrderType {
    UIView *bottomView = [[UIView alloc] init];
    
    if (_orderType == todo) {
        self.navigationItem.title = @"未进行工单";
        bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 163);
        UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 30, SCREEN_WIDTH - 32, 44)];
        agreeButton.backgroundColor = [UIColor colorWithHexString:@"#007AFF"];
        agreeButton.layer.cornerRadius = 5;
        agreeButton.layer.masksToBounds = YES;
        agreeButton.titleLabel.textColor = [UIColor whiteColor];
        [agreeButton addTarget:self action:@selector(agree) forControlEvents:UIControlEventTouchUpInside];
        [agreeButton setTitle:@"接单" forState:UIControlStateNormal];
        [bottomView addSubview:agreeButton];
        
        UIButton *refuseButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 89, SCREEN_WIDTH - 32, 44)];
        refuseButton.backgroundColor = [UIColor systemRedColor];
        refuseButton.layer.cornerRadius = 5;
        refuseButton.layer.masksToBounds = YES;
        refuseButton.titleLabel.textColor = [UIColor whiteColor];
        [refuseButton addTarget:self action:@selector(refuse) forControlEvents:UIControlEventTouchUpInside];
        [refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [bottomView addSubview:refuseButton];
    } else if (_orderType == doing) {
        self.navigationItem.title = @"进行中工单";
//        bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 281);
//        UIButton *statusButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 30, SCREEN_WIDTH - 32, 44)];
//        statusButton.backgroundColor = [UIColor colorWithHexString:@"#007AFF"];
//        statusButton.layer.cornerRadius = 5;
//        statusButton.layer.masksToBounds = YES;
//        statusButton.titleLabel.textColor = [UIColor whiteColor];
//        [statusButton addTarget:self action:@selector(checkStatus) forControlEvents:UIControlEventTouchUpInside];
//        [statusButton setTitle:@"查看运行状态" forState:UIControlStateNormal];
//        [bottomView addSubview:statusButton];
//
//        UIButton *historyButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 89, SCREEN_WIDTH - 32, 44)];
//        historyButton.backgroundColor = [UIColor colorWithHexString:@"#007AFF"];
//        historyButton.layer.cornerRadius = 5;
//        historyButton.layer.masksToBounds = YES;
//        historyButton.titleLabel.textColor = [UIColor whiteColor];
//        [historyButton addTarget:self action:@selector(checkHistory) forControlEvents:UIControlEventTouchUpInside];
//        [historyButton setTitle:@"查看维保历史" forState:UIControlStateNormal];
//        [bottomView addSubview:historyButton];
        
        
        bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 163);
        UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 30, SCREEN_WIDTH - 32, 44)];
        startButton.backgroundColor = [UIColor colorWithHexString:@"#007AFF"];
        startButton.layer.cornerRadius = 5;
        startButton.layer.masksToBounds = YES;
        startButton.titleLabel.textColor = [UIColor whiteColor];
        [startButton addTarget:self action:@selector(startMaintenance) forControlEvents:UIControlEventTouchUpInside];
        [startButton setTitle:@"开始维保" forState:UIControlStateNormal];
        [bottomView addSubview:startButton];
        
        UIButton *refuseButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 89, SCREEN_WIDTH - 32, 44)];
        refuseButton.backgroundColor = [UIColor systemRedColor];
        refuseButton.layer.cornerRadius = 5;
        refuseButton.layer.masksToBounds = YES;
        refuseButton.titleLabel.textColor = [UIColor whiteColor];
        [refuseButton addTarget:self action:@selector(refuseMaintenance) forControlEvents:UIControlEventTouchUpInside];
        [refuseButton setTitle:@"无法维保" forState:UIControlStateNormal];
        [bottomView addSubview:refuseButton];
    } else if (_orderType == checking) {
        self.navigationItem.title = @"工单审核中";
//        bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 104);
//        UIButton *auditButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 30, SCREEN_WIDTH - 32, 44)];
//        auditButton.backgroundColor = [UIColor colorWithHexString:@"#007AFF"];
//        auditButton.layer.cornerRadius = 5;
//        auditButton.layer.masksToBounds = YES;
//        auditButton.titleLabel.textColor = [UIColor whiteColor];
//        [auditButton addTarget:self action:@selector(seeOrder) forControlEvents:UIControlEventTouchUpInside];
//        [auditButton setTitle:@"查看维保内容" forState:UIControlStateNormal];
//        [bottomView addSubview:auditButton];
    } else if (_orderType == signing) {
        self.navigationItem.title = @"工单待签字";
    } else if (_orderType == done) {
        self.navigationItem.title = @"已完成工单";
    } else if (_orderType == kAudit) {
        self.navigationItem.title = @"待审核工单";
        bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 104);
        UIButton *auditButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 30, SCREEN_WIDTH - 32, 44)];
        auditButton.backgroundColor = [UIColor colorWithHexString:@"#007AFF"];
        auditButton.layer.cornerRadius = 5;
        auditButton.layer.masksToBounds = YES;
        auditButton.titleLabel.textColor = [UIColor whiteColor];
        [auditButton addTarget:self action:@selector(audit) forControlEvents:UIControlEventTouchUpInside];
        [auditButton setTitle:@"审核" forState:UIControlStateNormal];
        [bottomView addSubview:auditButton];
    }
    bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = bottomView;
}


- (void)agree {
    [self showProgress];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [UserService getUserInfo].userId;
    dic[@"workOrderId"] = _model.ID;
    dic[@"maintenanceTypeId"] = _model.MaintenanceTypeId;
    [NetRequest GET:@"NPMaintenanceApp/GetMaintenanceItem" params:dic callback:^(BaseModel *baseModel) {
        if (baseModel.success) {
            self.orderType = doing;
            [self setPageOrderType];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self showInfo:@"服务器错误"];
    }];
}

- (void)refuse {
    MaintenanceRefuseOrderViewController *vc = [MaintenanceRefuseOrderViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkStatus {
    
}

- (void)checkHistory {
    
}

- (void)startMaintenance {
    MaintenanceContentViewController *vc = [MaintenanceContentViewController new];
    vc.workOrderId = _model.ID;
    vc.maintenanceTypeId = _model.MaintenanceTypeId;
    vc.typeName = _model.TypeName;
    vc.address = _model.AddressPath;
    vc.isPreview = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refuseMaintenance {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionSheet1 = [UIAlertAction actionWithTitle:@"申请支援" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *actionSheet2 = [UIAlertAction actionWithTitle:@"维修申请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *cancelSheet = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:actionSheet1];
    [alertController addAction:actionSheet2];
    [alertController addAction:cancelSheet];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)seeOrder {

}

- (void)audit {
    MaintenanceAuditContentViewController *vc = [MaintenanceAuditContentViewController new];
    vc.workOrderId = _model.ID;
    vc.model = _model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
