//
//  ScrollWebImageView.h
//  WeiboDM
//
//  Created by ma yulong on 13-7-3.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomableImageView.h"
#import "ImageCacheManager.h"

@interface ScrollWebImageView : UIView <UIScrollViewDelegate,ImageLoadDelegate,ZoomableImageViewDelegate>

@property (nonatomic, assign) int clickedIndex;
@property(nonatomic,retain)UIImage *thumbImage;

- (id)initWithFrame:(CGRect)frame withUrls:(NSArray *)urlsArray andPreImages:(NSArray *)preImagesArray;

- (void)showFromView:(UIView *)aView;

@end
