

#import "SectionsViewController.h"
//#import "CampusLifeViewController.h"
#import <SMS_SDK/SMS_SDK.h>


@interface SectionsViewController ()
{
    NSMutableData*_data;
    int _state;
    NSString* _duid;
    NSString* _token;
    NSString* _appKey;
    NSString* _appSecret;
    NSMutableArray* _areaArray;
}


@end


@implementation SectionsViewController
@synthesize names;
@synthesize keys;
@synthesize table;
@synthesize search;
@synthesize allNames;
@synthesize allName;
#pragma mark -
#pragma mark Custom Methods
- (void)resetSearch
{
//    NSMutableDictionary *allNamesCopy;
//    self.names = allNamesCopy;
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
//    [keyArray addObject:UITableViewIndexSearch];
    [keyArray addObjectsFromArray:allName];
    self.keys = keyArray;
}
- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
    
//    for (NSString *key in self.keys) {
        NSMutableArray *array = keys;
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        for (NSString *name in self.keys) {
            if ([name rangeOfString:searchTerm 
                            options:NSCaseInsensitiveSearch].location == NSNotFound)
                [toRemove addObject:name];
        }
//        if ([array count] == [toRemove count])
//            [sectionsToRemove addObject:key];
        [array removeObjectsInArray:toRemove];
//    }
    [self.keys removeObjectsInArray:sectionsToRemove];
    [table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    isKey=NO;
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
    }
// 搜索页 写的自定义按钮点击事件
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 44+statusBarHeight)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    UIButton *btn_back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
    [btn_back setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barcItem = [[UIBarButtonItem alloc] initWithCustomView:btn_back];
//    NSArray *leftButtonItems=@[barcItem];
    [navigationItem setLeftBarButtonItem:barcItem];
    [navigationItem setTitle:NSLocalizedString(@"搜索城市", nil)];
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [self.view addSubview:navigationBar];
    
    search=[[UISearchBar alloc] init];
    search.frame=CGRectMake(0, 44+statusBarHeight, self.view.frame.size.width, 44);
    [self.view addSubview:search];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(0, 88+statusBarHeight, self.view.frame.size.width, self.view.bounds.size.height-(88+statusBarHeight)) style:UITableViewStylePlain];
    [self.view addSubview:table];

    table.dataSource=self;
    table.delegate=self;
    search.delegate=self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"country"
                                                     ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] 
                          initWithContentsOfFile:path];
    self.allNames = dict;

    [self resetSearch];
    [table reloadData];
//    [table setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title=@"选择学校";
////    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，键盘消失
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
-(void)setAreaArray:(NSMutableArray*)array
{
    _areaArray = [NSMutableArray arrayWithArray:array];
}

#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
//    if ([keys count] == 0)
//        return 0;
//    
//    NSString *key = [keys objectAtIndex:section];
//    NSArray *nameSection = [names objectForKey:key];
    return [self.keys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSUInteger section = [indexPath section];
//    NSString *key = [keys objectAtIndex:section];
//    NSArray *nameSection = [names objectForKey:key];
//    
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SectionsTableIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: SectionsTableIdentifier];
    }
    
    NSString* countryName=[self.keys objectAtIndex:indexPath.row];

    cell.textLabel.text=countryName;

    
//    [search resignFirstResponder];
//    cell.detailTextLabel.text=[NSString stringWithFormat:@"+%@",areaCode];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
    if ([keys count] == 0)
        return nil;
    NSString *key = [keys objectAtIndex:section];
    if (key == UITableViewIndexSearch)
        return nil;
    
    return nil;
}
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if (isSearching)
//        return nil;
//    return keys;
//}
#pragma mark -
#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [search resignFirstResponder];
    search.text = @"";
    isSearching = NO;
    [tableView reloadData];
    return indexPath;
}
- (NSInteger)tableView:(UITableView *)tableView 
sectionForSectionIndexTitle:(NSString *)title 
               atIndex:(NSInteger)index
{
    NSString *key = [keys objectAtIndex:index];
    if (key == UITableViewIndexSearch)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    else return index;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //传递数据
    if ([self.delegate respondsToSelector:@selector(setSecondData:)]) {
        [self.delegate setSecondData:[keys objectAtIndex:indexPath.row]];
    }
//    CampusLifeViewController * campisLViewController = [[CampusLifeViewController alloc] init];
    
    if (self.popBlock) {
        self.popBlock();
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    //关闭当前
//    [self clickLeftButton];
}
- (void)tiaozhuan:(PopPageViewBlock)temp{
    
    self.popBlock = temp;
}


#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
//    [searchBar resignFirstResponder];
    [search resignFirstResponder];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
    [table reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar 
    textDidChange:(NSString *)searchTerm
{
    if ([searchTerm length] == 0)
    {
        [self resetSearch];
        [table reloadData];
        return;
    }
    
    [self handleSearchForTerm:searchTerm];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearching = NO;
    search.text = @"";

    [self resetSearch];
    [table reloadData];
    
    [searchBar resignFirstResponder];
}

-(void)clickLeftButton
{
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    [self addScreenTouchObserver];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self removeScreenTouchObserver];
}

#pragma mark - 移除触摸观察者
- (void)removeScreenTouchObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nScreenTouch" object:nil];//移除nScreenTouch事件
}
#pragma mark - 添加触摸观察者
- (void)addScreenTouchObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScreenTouch:) name:@"nScreenTouch" object:nil];
}

-(void)onScreenTouch:(NSNotification *)notification {
    UIEvent *event=[notification.userInfo objectForKey:@"data"];
    NSSet *allTouches = event.allTouches;
    UITouch *touch=allTouches.anyObject;
    switch (touch.phase) {
        case UITouchPhaseBegan:
            break;
        case UITouchPhaseMoved:
        {
            [search resignFirstResponder];
        }
            break;
        case UITouchPhaseCancelled:
            break;
        case UITouchPhaseEnded:
            break;
        case UITouchPhaseStationary:
        {
            [search resignFirstResponder];
        }
            break;
        default:
            break;
    }
}



@end
