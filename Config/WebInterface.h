//
//  WebInterface.h
//  Sea_northeast_asia
//
//  Created by Lym on 2020/1/8.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef WebInterface_h
#define WebInterface_h

// 老旧电梯线下
static NSString * const old_base = @"http://192.168.1.125:8060/";
// 老旧电梯api线下
static NSString * const old_base_api = @"http://192.168.1.125:8060/api/";

//// 老旧电梯
//static NSString * const old_base = @"http://123.57.164.210:8060/";
//// 老旧电梯api
//static NSString * const old_base_api = @"http://123.57.164.210:8060/api/";

/* 登录 */
static NSString * const account_login = @"Account/Login";
/* 上传文件 */
static NSString * const account_uploadFile = @"Account/UploadFile";
/* 更新签名 */
static NSString * const account_updateUserSign = @"Account/UpdateUserSign";
/* 修改密码 */
static NSString * const account_updatePassword = @"Account/UpdatePassword";


#pragma mark - ---------- 园区环境 ----------
/* 园区环境评估首页列表 */
static NSString * const task_getMaintenanceManage = @"Task/GetMaintenanceManage";

/* 园区环境评估详情 */
static NSString * const task_getEnvironmentAssessmentEntityByTaskId = @"Task/GetEnvironmentAssessmentEntityByTaskId";

/* 园区环境评估提交 */
static NSString * const task_saveEnvironmentAssessment = @"Task/SaveEnvironmentAssessment";

#pragma mark - ---------- 评估 ----------
/* 评估首页列表 */
static NSString * const task_getTaskManageByFlowStatusActionsId = @"Task/GetTaskManageByFlowStatusActionsId";

/* 评估详情 */
static NSString * const task_getTaskMessageDetailsById = @"Task/GetTaskMessageDetailsById";

/* 评估部件列表 */
static NSString * const task_getAssessmentItemByTaskId = @"Task/GetAssessmentItemByTaskId";

/* 评估部件检查是否完成 */
static NSString * const task_checkPartAssessmentItem = @"Task/CheckPartAssessmentItem";

/* 评估部件检查提交 */
static NSString * const task_savePartAssessment = @"Task/SavePartAssessment";

/* 风险部件列表 */
static NSString * const task_getElevatorRiskPartByTaskId = @"Task/GetElevatorRiskPartByTaskId";

/* 风险部件选择部件列表 */
static NSString * const task_getPartsByTaskId = @"Task/GetPartsByTaskId";

/* 已提交的风险部件选择部件列表 */
static NSString * const task_getElevatorPartRecordByTaskId = @"Task/GetElevatorPartRecordByTaskId";

/* 话语列表 */
static NSString * const task_getDiscourseTemplateManagements = @"Task/GetDiscourseTemplateManagements";

/* 评估提交 */
static NSString * const task_saveParts = @"Task/SaveParts";


#pragma mark - ---------- 施工 ----------
/* 施工首页列表 */
static NSString * const reformTask_getTaskManageByFlowStatusActionsId = @"ReformTask/GetTaskManageByFlowStatusActionsId";

/* 部件首页列表 */
static NSString * const reformTask_getBindPartTaskManageByFlowStatusActionsId = @"ReformTask/GetBindPartTaskManageByFlowStatusActionsId";

/* 部件详情 */
static NSString * const reformTask_getTaskMessageDetailsById = @"ReformTask/GetTaskMessageDetailsById";

/* 部件列表 */
static NSString * const reformTask_getElevatorPartRecordByTaskId = @"ReformTask/GetElevatorPartRecordByTaskId";

/* 绑定/修改待更换部件 */
static NSString * const reformTask_saveConstructionPart = @"ReformTask/SaveConstructionPart";

/* 出库 */
static NSString * const reformTask_saveDeliverGoods = @"ReformTask/SaveDeliverGoods";

/* 返库 */
static NSString * const reformTask_saveReturnReason = @"ReformTask/SaveReturnReason";

/* 提交 */
static NSString * const reformTask_saveConstructionInfo = @"ReformTask/SaveConstructionInfo";


#pragma mark - ---------- 检验 ----------
/* 检验首页列表 */
static NSString * const examineTask_getTaskManageByFlowStatusActionsId = @"ExamineTask/GetTaskManageByFlowStatusActionsId";

/* 开始检验 */
static NSString * const examineTask_updateTaskStatus = @"ExamineTask/UpdateTaskStatus";

/* 检验详情 */
static NSString * const examineTask_getTaskDetailById = @"ExamineTask/GetTaskDetailById";

/* 检验项目列表 */
static NSString * const examineTask_getExamineProject = @"ExamineTask/GetExamineProject";

/* 检验提交 */
static NSString * const examineTask_saveExamine = @"ExamineTask/SaveExamine";


#endif /* WebInterface_h */
