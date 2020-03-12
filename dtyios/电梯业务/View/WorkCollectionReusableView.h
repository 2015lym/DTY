//
//  WorkCollectionReusableView.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/3.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WorkCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

#ifdef __IPHONE_11_0
@interface CustomLayer : CALayer

@end
#endif
