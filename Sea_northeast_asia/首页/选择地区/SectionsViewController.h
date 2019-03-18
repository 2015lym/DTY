

#import <UIKit/UIKit.h>

#import <SMS_SDK/CountryAndAreaCode.h>
#import "UIViewControllerEx.h"
@protocol SecondViewControllerDelegate;

#pragma mark 1.给block起别名
typedef void(^PopPageViewBlock) ();


@interface SectionsViewController : UIViewControllerEx
<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *table;
    UISearchBar *search;
    NSDictionary *allNames;
    NSMutableDictionary *names;
    NSMutableArray  *keys;    
    
    BOOL    isSearching;
    BOOL  isKey;
}



#pragma mark 2.block声明
@property (nonatomic, copy) PopPageViewBlock popBlock;

#pragma mark block方法
- (void)tiaozhuan:(PopPageViewBlock)temp;

@property (nonatomic, strong)  UITableView *table;
@property (nonatomic, strong)  UISearchBar *search;
@property (nonatomic, strong) NSDictionary *allNames;
@property (nonatomic, strong) NSMutableDictionary *names;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic ,strong) NSMutableArray *allName;

@property (nonatomic, strong) id<SecondViewControllerDelegate> delegate;
@property(nonatomic,strong)  UIToolbar* toolBar;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;
-(void)setAreaArray:(NSMutableArray*)array;

@end

@protocol SecondViewControllerDelegate <NSObject>
- (void)setSecondData:(NSString *)data;







@end


