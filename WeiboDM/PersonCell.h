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

@protocol PersonCellDelegate <NSObject>

- (void)openSmallImages:(NSArray *)imageUrls preImages:(NSArray *)preImages andCurrentIndex:(int)index;

@end

@interface PersonCell : UITableViewCell <OHAttributedLabelDelegate>

@property (nonatomic, weak) id <PersonCellDelegate> delegate;

- (void)updateCellWithData:(SinaWeiboModel *)model;
+ (float)calculateCardHeight:(SinaWeiboModel *)model;

@end
