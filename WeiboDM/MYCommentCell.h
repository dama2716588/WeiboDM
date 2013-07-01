//
//  MYCommentCell.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-13.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaCommentsModel.h"

@interface MYCommentCell : UITableViewCell

+ (CGFloat)heightForCell:(SinaCommentsModel *)model;
- (void)updateDataWith:(SinaCommentsModel *)model;
@end
