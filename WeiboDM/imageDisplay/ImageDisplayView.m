
//
//  ImageDisplayView.m
//  pento
//
//  Created by xntech on 13-7-1.
//  Copyright (c) 2013年 Pento. All rights reserved.
//

#import "ImageDisplayView.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@implementation ImageDisplayView

- (void)setUrl:(NSURL *)url andPreImage:(UIImage *)image
{
    if (image != nil)
    {
        [_imageView setFrame:[Helper zoomImageRectFromSize:image.size]];
    }
    
    [_indicatorView startAnimating];
    [self addSubview:_indicatorView];
    
    __weak UIActivityIndicatorView  *indicatorView = _indicatorView;
    __weak UIImageView  *imageView = _imageView;
    __weak UIScrollView  *zoomeScrollView = _zoomScrollView;
    __weak UILabel    *tipLabel = _tipLabel;
    __weak UIView     *me = self;
    [_imageView setImageWithURL:url placeholderImage:image completed:^(UIImage *fImage,NSError *error,SDImageCacheType type)
    {
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        if (error)
        {
            [me addSubview:tipLabel];
        }
        else
        {
            [tipLabel removeFromSuperview];
            CGRect rect = [Helper zoomImageRectFromSize:fImage.size];
            float width_scale = fImage.size.width/rect.size.width;
            float height_scale = fImage.size.height/rect.size.height;
            float scale = MAX(width_scale, height_scale);
            if (scale < 0) {
                scale = 1;
            }
            [zoomeScrollView setMaximumZoomScale:2 * scale];
            
            if (fImage != nil)
            {
                [imageView setAlpha:0.0f];
                [imageView setFrame:rect];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.8f];
                [imageView setAlpha:1.0f];
                [UIView commitAnimations];
            }
        }
    }];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _zoomScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_zoomScrollView setMinimumZoomScale:0.6f];
        [_zoomScrollView setMaximumZoomScale:2.0f];
        [_zoomScrollView setDelegate:self];
        [_zoomScrollView setShowsHorizontalScrollIndicator:NO];
        [_zoomScrollView setShowsVerticalScrollIndicator:NO];
        
        _imageView = [[SCGIFImageView alloc] initWithFrame:CGRectZero];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView setContentMode:UIViewContentModeScaleToFill];

        [self addSubview:_zoomScrollView];
        [_zoomScrollView addSubview:_imageView];
        
        UITapGestureRecognizer *imgTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_zoomScrollView addGestureRecognizer:imgTapped];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_tipLabel setBackgroundColor:[UIColor clearColor]];
        [_tipLabel setText:@"微博原始图片加载失败！"];
        [_tipLabel setTextColor:[UIColor whiteColor]];
        [_tipLabel setTextAlignment:NSTextAlignmentCenter];
        [self orientationChanged];

    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)sview atScale:(float)scale
{
//    CGRect originFrame = [_imageView frame];
//    float width = originFrame.size.width;
//    float height = originFrame.size.height;
//    
//    float screenWidth = SCREEN_WIDTH;
//    float screenHeight = SCREEN_HEIGHT;
//    
//    float x = (screenWidth - width)/2.0;
//    float y = (screenHeight - height)/2.0;
//    if (x < 0) {
//        x = 0;
//    }
//    if (y < 0) {
//        y = 0;
//    }
//    originFrame.origin = CGPointMake(x, y);
//    [UIView beginAnimations:nil context:nil];
//    [_imageView setFrame:originFrame];
//    [UIView commitAnimations];
}
- (void)dismiss
{
    self.dissmissAction();
}

- (void)orientationChanged
{
    [_zoomScrollView setZoomScale:1.0f];
    [_zoomScrollView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_imageView setFrame:[Helper zoomImageRectFromSize:_imageView.image.size]];
    [self setFrame:CGRectMake(self.tag * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];    
    [_indicatorView setCenter:CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/2.0f)];
    [_tipLabel setFrame:CGRectMake(0, (SCREEN_HEIGHT - 100)/2, SCREEN_WIDTH, 100)];
    
}

- (UIImage *)getImage
{
    return [_imageView image];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ?
    scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?
    scrollView.contentSize.height/2 : ycenter;
    [_imageView setCenter:CGPointMake(xcenter, ycenter)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
@end
