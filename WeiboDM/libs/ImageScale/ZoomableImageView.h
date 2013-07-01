//
//  ZoomableImageView.h
//
//  Created by 诗彬 刘 on 12-3-15.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHGIFImageView.h"

@protocol ZoomableImageViewDelegate;
@interface ZoomableImageView : UIScrollView <UIScrollViewDelegate> {
    GHGIFImageView *_imageView;
    int _index;
    BOOL _canClickScale;     //if the maxscale equals to minscale, the image can't support click enlarge
    id<ZoomableImageViewDelegate> _tapDelegate;
}
@property (nonatomic, assign) int index;
@property (nonatomic, assign) id<ZoomableImageViewDelegate> tapDelegate;
@property (nonatomic, retain) id image;

- (void)setImage:(id)image;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;
- (void)setMaxMinZoomScalesForCurrentBounds;
@end

@protocol ZoomableImageViewDelegate <NSObject>
@optional
- (void)imageZoomableViewSingleTapped:(ZoomableImageView*)imageZoomableView inImage:(BOOL)inImage;

@end