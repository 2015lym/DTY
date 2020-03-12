//
//  Part_EditCellDelegate.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/13.
//  Copyright © 2019 SongQues. All rights reserved.
//

#ifndef Part_EditCellDelegate_h
#define Part_EditCellDelegate_h

typedef NS_ENUM(NSUInteger, EditAction) {
    edit_bind,
    edit_change,
    edit_back,
    edit_out,
    edit_reason
};

@protocol Part_EditCellDelegate <NSObject>

- (void)cellEditAction:(EditAction)action andIndexPath:(NSIndexPath *)indexPath;

@end


#endif /* Part_EditCellDelegate_h */
