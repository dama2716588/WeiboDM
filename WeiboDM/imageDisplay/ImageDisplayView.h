//
//  ImageDisplayView.h
//  pento
//
//  Created by xntech on 13-7-1.
//  Copyright (c) 2013年 Pento. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGIFImageView.h"

typedef void(^ImageDisplayViewDidDismiss)(void);

@interface ImageDisplayView : UIView<UIScrollViewDelegate>
{
    UIScrollView  *_zoomScrollView;
    SCGIFImageView   *_imageView;
    UIActivityIndicatorView   *_indicatorView;
    
    UILabel    *_tipLabel;
}
@property (nonatomic,copy)ImageDisplayViewDidDismiss dissmissAction;


- (void)setUrl:(NSURL *)url andPreImage:(UIImage *)image;
- (void)orientationChanged;
- (UIImage *)getImage;
@end
