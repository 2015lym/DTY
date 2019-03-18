//
//  ConvenienceViewIOSController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/8/11.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavViewControllerEx.h"
#import "AFAppDotNetAPIClient.h"
#import "JSONKit.h"
@class CustomCollectionViewLayout;
@interface ConvenienceViewIOSController : UINavViewControllerEx<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
       NSMutableArray *_allTypes;
    
    NSMutableArray *_allCity;
    __weak IBOutlet UIScrollView *_scrollView;
    
    NSString *str_CachePath_FacTypeAll;
}

@end
