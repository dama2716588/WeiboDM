//
//  SinaWeiboCell.h
//  WeiboDM
//
//  Created by ma yulong on 13-5-26.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "PSTCollectionView.h"
#import "SinaWeiboModel.h"
#import "OHAttributedLabel.h"

@protocol SinaWeiboCellDelegate <NSObject>
@optional
- (void)openWeiboWithUrl:(NSString *)url;
- (void)gotoPersonWith:(SinaUserModel *)sinaUser;
@end

@interface SinaWeiboCell:PSUICollectionViewCell <OHAttributedLabelDelegate>
- (void)updateCellWithData:(SinaWeiboModel *)model;
+ (float)calculateCardHeight:(SinaWeiboModel *)model;

@property (nonatomic, assign) NSObject<SinaWeiboCellDelegate> *delegate;
@property (nonatomic, retain) UIImage *repostBGImage;
@end