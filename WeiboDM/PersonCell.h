//
//  PersonCell.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-16.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeiboModel.h"
#import "OHAttributedLabel.h"

@interface PersonCell : UITableViewCell <OHAttributedLabelDelegate>

- (void)updateCellWithData:(SinaWeiboModel *)model;
+ (float)calculateCardHeight:(SinaWeiboModel *)model;

@end
