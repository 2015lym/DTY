//
//  WorkCollectionView.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/3.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "WorkCollectionView.h"

@implementation WorkCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (SCREEN_WIDTH > 375) {
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-60) / 4, (SCREEN_WIDTH-60) / 4 + 10);
    } else {
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-40) / 3, (SCREEN_WIDTH-40) / 3);
    }
    
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 44);
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self registerNib:[UINib nibWithNibName:@"WorkCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    [self registerNib:[UINib nibWithNibName:@"WorkCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableId"];
    return self;
}

@end
