//
//  SelectSchoolViewController.m
//  AlumniChat
//
//  Created by xiaoanzi on 15-3-24.
//  Copyright (c) 2015年 xiaoanzi. All rights reserved.
//

#import "SelectSchoolViewController.h"
//#import "SelectFacultyViewController.h"
#import "JSONKit.h"
@interface SelectSchoolViewController ()
{
     UITableView *schoolTableView;
}
@end

@implementation SelectSchoolViewController
@synthesize schoolEntity;
@synthesize userInfoEntity;
@synthesize arr_school;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (userInfoEntity!=nil) {
       //str_schoolID=userInfoEntity.str_xueID;
        //str_shcoolName=userInfoEntity.str_xuexiao;
    }

    
    [self createEditableCopyOfDatabaseIfNeeded];
   
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self.navigationController.navigationBar viewWithTag:10000] removeFromSuperview];
    self.navigationItem.title=@"选择城市";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createEditableCopyOfDatabaseIfNeeded
{
    // 先判断 sandbox 下面的 documents 子文件夹里面有没有数据库文件 test.sqlite
    str_CachePath_AreasAll = [NSString stringWithFormat:@"%@%@",[Util GetMyCachesPath],@"AreasAll"];
    allCity=[NSMutableArray arrayWithContentsOfFile:str_CachePath_AreasAll];
    if (allCity!=nil)
    {
        [self Link_Database];
    }
    else{
        [self getCityCode];
    }
   
}

//得到城市列表
-(void)getCityCode
{
    
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"index.php/News/getCityInfo"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"state"] intValue];
             NSDictionary* dic_resultValue=[dic_result objectForKey:@"result"];
             if (state_value==0) {
                 
                 allCity=[NSMutableArray arrayWithArray:[dic_resultValue objectForKey:@"cityInfo"]];
                 
                 
                 /*缓存标签*/
                  [allCity writeToFile:str_CachePath_AreasAll atomically:YES];//缓存所有标签
                 /*^^^^缓存标签^^^^*/

                 
                 [self Link_Database];
             }
             else
             {
                 [self showAlter:@"获取城市信息失败！"];
                 [self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
             }
             
         }
         else
         {
             [self showAlter:@"获取城市信息失败！"];
             [self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"获取城市信息失败！"];
         [self performSelector:@selector(getTags) withObject:nil afterDelay:3.0];
     }];
    
}

-(void)showAlter:(NSString *)massage{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:massage
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
    [alert show];
    
}


-(void)Link_Database
{
    dic_data=[NSMutableArray array];
    arr_data_name=[NSMutableArray array];
    //定位到的城市
     arr_data=[NSMutableArray array];
    NSDictionary *dic;
    //if([_currAreaId isEqualToString:@""])
    if(nil==_currAreaId )
    {
    dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       @"", @"tagId",
                        @"", @"tagName",
                       nil];
    }
    else
    {
        dic=[NSDictionary dictionaryWithObjectsAndKeys:
             _currAreaId, @"tagId",
             _currAreaName, @"tagName",
             nil];
    }
    [ arr_data addObject:dic];
    [dic_data addObject:arr_data ];
    [arr_data_name  addObject:@"定位到的城市"];
    
    //经常选择的城市
    str_CachePath_select = [NSString stringWithFormat:@"%@%@",[Util GetMyCachesPath],@"AreasSelect"];
    select_data=[NSMutableArray arrayWithContentsOfFile:str_CachePath_select];
    if(select_data!=nil)
    {
    [dic_data addObject:select_data ];
    [arr_data_name  addObject:@"经常选择的城市"];
    }
    
   for (NSMutableDictionary *dic_item in allCity) {
        arr_data=[NSMutableArray arrayWithArray:[dic_item objectForKey:@"cityList"]];
       [dic_data addObject:arr_data ];
       [arr_data_name  addObject:[dic_item objectForKey:@"tagName"]];
       
       /*
        SchoolEntity *Entity=[[SchoolEntity alloc]init];
        Entity.m_nUniversity_ID=[dic_item objectForKey:@"tagId"];//学校id
        Entity.m_nUniversity_Name=[dic_item objectForKey:@"tagName"];;//学校名称
        Entity.type=@"2";
        [arr_data addObject:Entity];
       */
    }
    
     [table_view reloadData];
}

-(NSMutableArray *)Link_Database_all
{
    NSMutableArray *arr=[NSMutableArray array];
    for (NSMutableDictionary *dic_item in allCity)  {
        arr_data=[NSMutableArray arrayWithArray:[dic_item objectForKey:@"cityList"]];
        for (NSMutableDictionary *curr_item in arr_data)  {
        NSString *str=[NSString stringWithFormat:@"%@",[curr_item objectForKey:@"tagName"]];
        if (![self isBlankString:str]) {
            [arr addObject:str];
        }
        }
    }
    
    return arr;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
/*
-(NSMutableArray *)Like_Database:(NSString *)string
{
    fmdDB=[FMDatabase databaseWithPath: [[NSBundle mainBundle] pathForResource:@"school" ofType:@"sqlite"]];
    [fmdDB open];
    NSString *str_sql=@"select _id,* from t_universities where m_nUniversity_Name=?";
    FMResultSet *result_set=[fmdDB executeQuery:str_sql,string];
    NSMutableArray *arr=[NSMutableArray array];
    while ([result_set next]) {
        SchoolEntity *Entity=[[SchoolEntity alloc]init];
        Entity.m_nUniversity_ID=[result_set stringForColumn:@"m_nUniversity_ID"];
        Entity.m_nUniversity_Name=[result_set stringForColumn:@"m_nUniversity_Name"];
        Entity.m_id=[result_set stringForColumn:@"_id"];
        Entity.m_nUniversity_Pinyin=[result_set stringForColumn:@"m_nUniversity_Pinyin"];
        Entity.m_nProvince_Name=[result_set stringForColumn:@"m_nProvince_Name"];
        Entity.type=@"1";
        [arr addObject:Entity];
    }
    [fmdDB close];
    return arr;
}

 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *currArr=dic_data[section];
    if(section==0 &&_currAreaId ==nil)
    {
        return 0;
    }
    else
    {
    return currArr.count;
    }
}
//多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return dic_data.count;
}
//每行显示的数
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    NSMutableArray *currArr=dic_data[indexPath.section];
    
    NSDictionary *curr_item=currArr[indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[curr_item objectForKey:@"tagName"]];
    cell.textLabel.tag=[[NSString stringWithFormat:@"%@",[curr_item objectForKey:@"tagId"]] intValue];
    NSLog(@"indexPath%ld",(long)indexPath.row);

    return cell;
}
/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{    

    view_SchoolR.frame=CGRectMake(0, 0, 100, 100);
        return view_SchoolR;

}
*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *curr=arr_data_name[section];
    return curr;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *currArr=dic_data[indexPath.section];
    
    NSDictionary *curr_item=currArr[indexPath.row];
    NSString *text=[NSString stringWithFormat:@"%@",[curr_item objectForKey:@"tagName"]];
    NSString *tag=[NSString stringWithFormat:@"%@",[curr_item objectForKey:@"tagId"]] ;
    [self isInSelectdata:tag forName:text];
    
     [ _delegate returnAreainfo:tag forAreaname:text];
      [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)isInSelectdata:(NSString *)areaid forName:(NSString *)name
{
    NSDictionary  *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                        areaid, @"tagId",
                        name, @"tagName",
                        nil];
    if(select_data==nil)
    {
        select_data=[NSMutableArray array];
        [select_data addObject:dic];
    }
    else
    {
        for (NSMutableDictionary * curr_item in select_data) {
            NSString *currid=[curr_item objectForKey:@"tagId"];
            if([areaid isEqualToString: currid])
            {
                [select_data removeObject:curr_item];
                break;
            }
        }
        [select_data insertObject:dic atIndex:0];
    }
    
    if(select_data.count>=6)
    {
        [select_data removeLastObject];
    }
    [select_data writeToFile:str_CachePath_select atomically:YES];//缓存所有标签

}

-(IBAction)btn_select_OnClick:(id)sender
{
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SectionsViewController* country2=[[SectionsViewController alloc] init];
    country2.delegate=self;
    country2.allName=[self Link_Database_all];
    [self presentViewController:country2 animated:YES completion:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}

#pragma mark - SecondViewController Delegate
- (void)setSecondData:(NSString *)data
{
    
    [ _delegate returnAreainfo:[self getAreaId:data] forAreaname:data];
 [self.navigationController popToRootViewControllerAnimated:YES];
}
     -(NSString *)getAreaId:(NSString *)areaName
{
    NSString *areaid=@"643";
    for (NSMutableDictionary *dic_item in allCity) {
        arr_data=[NSMutableArray arrayWithArray:[dic_item objectForKey:@"cityList"]];
        
        for (NSMutableDictionary * curr_item in arr_data) {
            NSString *currName=[curr_item objectForKey:@"tagName"];
         if([areaName isEqualToString: currName])
         {
             areaid=[curr_item objectForKey:@"tagId"];
             return areaid;
         }
        }
    }
    
    return areaid;
}
-(void)nav_back:(id)sender
{
    if (userInfoEntity!=nil) {
        //userInfoEntity.str_xuexiao=str_shcoolName;
        //userInfoEntity.str_xueID=str_schoolID;
    }
    [super nav_back:sender];
}
@end
