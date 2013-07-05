//
//  ScrollWebImageView.m
//  WeiboDM
//
//  Created by ma yulong on 13-7-3.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "ScrollWebImageView.h"

#define TRANSITION_TIME     0.4f
#define TRANSITION_KEY      @"transition_key"

@implementation ScrollWebImageView
{
    UIScrollView *_largeScrollView;
    NSArray *_urlsArray;
    NSArray *_preImagesArray;
    UIActivityIndicatorView *loadingView;
    
    int _indexCurrent;    
}

- (id)initWithFrame:(CGRect)frame withUrls:(NSArray *)urlsArray andPreImages:(NSArray *)preImagesArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _urlsArray = urlsArray;
        _preImagesArray = preImagesArray;
                
        _largeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.height)];
        _largeScrollView.backgroundColor = [UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:0.9f];
        _largeScrollView.showsHorizontalScrollIndicator = NO;
        _largeScrollView.showsVerticalScrollIndicator = NO;
        _largeScrollView.pagingEnabled = YES;
        _largeScrollView.delegate = self;
        [self addSubview:_largeScrollView];
        [_largeScrollView setContentSize:CGSizeMake(320 * [_urlsArray count] , self.height)];
        
        for (int i=0; i<urlsArray.count; i++) {
            ZoomableImageView *imageView = [[ZoomableImageView alloc] initWithFrame:self.bounds];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            imageView.tapDelegate = self;
            imageView.userInteractionEnabled = YES;
            UIImage *image = [((UIView *)[preImagesArray objectAtIndex:i]) imageFromView];
            imageView.image = image;            
            [_largeScrollView addSubview:imageView];
            [imageView changePosition:CGPointMake(i*320, 0)];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
            [imageView addGestureRecognizer:tap];
            
        }
        
    }
    return self;
}

- (void)showFromView:(UIView *)aView
{
    UIView *window = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    window.userInteractionEnabled = YES;
    [window addSubview:self];
    
    if (self.clickedIndex > 0) [_largeScrollView setContentOffset:CGPointMake(self.clickedIndex * 320, 0) animated:NO];    
    
    [self loadImageWithIndex:self.clickedIndex];
}

- (void)loadImageWithIndex:(int)index{
    
    _indexCurrent = index;
    
    if (!loadingView) {
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingView.center = self.centerOfView;
        loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:loadingView];
    }
    [loadingView startAnimating];
    
    NSString *thunbUrl = [[_urlsArray objectAtIndex:_indexCurrent] objectForKey:@"thumbnail_pic"];
    NSString *largeUrl = [thunbUrl stringByReplacingOccurrencesOfString:@"/thumbnail/" withString:@"/large/"];    
    [[ImageCacheManager sharedImageCacheManager] loadImageWithDelegate:self url:largeUrl];
}

-(void)imageDidLoad:(UIImage *)image url:(NSString *)url usingCache:(BOOL)isCache{
    [loadingView stopAnimating];
    
    ZoomableImageView *imageView = (ZoomableImageView *)[_largeScrollView.subviews objectAtIndex:_indexCurrent];
    imageView.image = image;
    imageView.maximumZoomScale = 2.4;
    imageView.minimumZoomScale = 0.8;
    [imageView restoreCenterPoint:self.centerOfView scale:1];    
}

- (void)close:(UITapGestureRecognizer *)tap
{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animated{
    [UIView animateWithDuration:animated?0.25:0.01
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x/320;
    NSLog(@"indexxxxx : %d",index);
    
    _indexCurrent = index;
    [self loadImageWithIndex:_indexCurrent];
}

@end
