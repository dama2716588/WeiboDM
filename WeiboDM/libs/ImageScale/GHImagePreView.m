//
//  GHImagePreVIew.m
//  notebook
//
//  Created by 诗彬 刘 on 12-5-17.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import "GHImagePreView.h"
#import "ZoomableImageView.h"
#import "ImageCacheManager.h"
#import <QuartzCore/QuartzCore.h>

#define TRANSITION_TIME     0.4f
#define TRANSITION_KEY      @"transition_key"

@interface GHImagePreView()<ImageLoadDelegate,ZoomableImageViewDelegate>{
    ZoomableImageView *imageView;
    UIActivityIndicatorView *loadingView;
    UIButton *extractBtn;
}
- (void)loadImage;
@end

@implementation GHImagePreView
@synthesize image = _image;
@synthesize thumbImage = _thumbImage;
@synthesize imageUrl = _imageUrl;

- (void)dealloc{
    [loadingView release];
    [_imageUrl release];
    [imageView release];
    [_thumbImage release];
    [_image release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIControl *maskView = [[UIControl alloc] initWithFrame:self.bounds];
        maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0;
        [maskView addTarget:self action:@selector(taped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:maskView];
        [UIView animateWithDuration:1. animations:^{
            maskView.alpha = 0.8;
        } completion:^(BOOL finished) {
        }];
        [maskView release];
        
        imageView = [[ZoomableImageView alloc] initWithFrame:self.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        imageView.tapDelegate = self;
        [self addSubview:imageView];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
//        tap.numberOfTapsRequired = 1;
//        [imageView addGestureRecognizer:tap];
//        [tap release];
        
        extractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [extractBtn setBackgroundImage:[UIImage imageNamed:@"extract_image"] forState:UIControlStateNormal];
        [extractBtn setBackgroundImage:[UIImage imageNamed:@"extract_images"] forState:UIControlStateHighlighted];
        [extractBtn sizeToFit];
        extractBtn.center = CGPointMake(self.width/2, self.height - 50);
        extractBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:extractBtn];
        [extractBtn addTarget:self action:@selector(extract:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl{
    if (![imageUrl isEqualToString:_imageUrl]) {
        [_imageUrl release];
        _imageUrl = [imageUrl copy];
    }
}

- (void)showFromView:(UIView *)aView{
    
    extractBtn.hidden = YES;
    
    UIView *window = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    self.frame = window.bounds;
    CGRect originRect = [aView.superview convertRect:aView.frame toView:window];
    
    if (!_thumbImage) {
        UIImage *image = [aView imageFromView];
        self.thumbImage = image;
    }
    
    imageView.image = _thumbImage;
    imageView.userInteractionEnabled = NO;
    
    CGSize size = self.thumbImage.size;
    size.height *= 4;
    size.width *= 4;
    if (size.width>window.width||size.height>window.height) {
        CGFloat scale = MIN(window.width/size.width, window.height/size.height);
        size.height*=scale;
        size.width*=scale;
    }
    
    CGRect finalRect = CGRectMakeWithCenterAndSize(window.centerOfView, size);
    
    [window addSubview:self];
    
	CATransformLayer *transformLayer = [CATransformLayer layer];
	transformLayer.frame = finalRect;
    
    CATransform3D t = CATransform3DMakeTranslation(CGRectGetCenter(originRect).x-CGRectGetCenter(finalRect).x, 
                                                   CGRectGetCenter(originRect).y-CGRectGetCenter(finalRect).y, 
                                                   0);
    CATransform3D transform = CATransform3DScale(t,
                                                 originRect.size.width/finalRect.size.width,
                                                 originRect.size.height/finalRect.size.height,
                                                 1); 
    transformLayer.anchorPoint = CGPointMake(0.5, 0.5);
    [transformLayer setTransform:transform];
    
	[window.layer addSublayer:transformLayer];
    
    CALayer *frontLayer = [CALayer layer];
	frontLayer.contents = (id)[aView imageFromView].CGImage;
	frontLayer.doubleSided = NO;
	frontLayer.frame = transformLayer.bounds;
	frontLayer.masksToBounds = NO;
	[transformLayer addSublayer:frontLayer];
    
    
	CALayer *backLayer = [CALayer layer];
	backLayer.contents = (id)_thumbImage.CGImage;
	backLayer.doubleSided = NO;
	backLayer.frame = transformLayer.bounds;
	backLayer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0);
	[transformLayer addSublayer:backLayer];
    
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D z = CATransform3DMakeTranslation(0, 0, finalRect.size.width);
	animation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(z,M_PI*0.999, 0.0f, 1.0f, 0.0)];
    
    
	CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
	animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
    
    CAAnimationGroup *grouop = [CAAnimationGroup animation];
    grouop.animations = [NSArray arrayWithObjects:animation,animation1,nil];
    grouop.fillMode = kCAFillModeForwards;
    [grouop setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    grouop.removedOnCompletion = NO;
    grouop.delegate = self;
    grouop.duration = TRANSITION_TIME*1.5;
    [grouop setValue:transformLayer forKey:@"transformLayer"];
    
	[transformLayer addAnimation:grouop forKey:TRANSITION_KEY];
    
    self.hidden = YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.hidden = NO;
    if (flag) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [[anim valueForKey:@"transformLayer"] removeFromSuperlayer];
        CALayer *layer = [anim valueForKey:@"transformLayer"];
        [layer removeAnimationForKey:TRANSITION_KEY];
        [self loadImage];
    }
}

- (void)taped:(id)sender{
    [self dismiss:YES];
}

- (void)loadImage{
    if (!loadingView) {
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingView.center = self.centerOfView;
        loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:loadingView];
    }
    [loadingView startAnimating];
    [[ImageCacheManager sharedImageCacheManager] loadImageWithDelegate:self url:_imageUrl];
}

-(void)imageDidLoad:(UIImage *)image url:(NSString *)url usingCache:(BOOL)isCache{
    [loadingView stopAnimating];
    extractBtn.hidden = NO;
    
    imageView.image = image;
    imageView.maximumZoomScale = 2.4;
    imageView.minimumZoomScale = 0.8;
    imageView.userInteractionEnabled = YES;
    [imageView restoreCenterPoint:self.centerOfView scale:1];
}

- (void)dismiss:(BOOL)animated{
    [UIView animateWithDuration:animated?0.25:0.01
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)extract:(id)sender{
    UIImage *resizedImage = [imageView.image scaleImageToSize:900.0f];
    CGRect frame = CGRectMakeWithCenterAndSize(self.centerOfView,[resizedImage size]);
    [self dismiss:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = [touch tapCount];
    if (tapCount == 1) {
        [self dismiss:YES];
    }
}

- (void)imageZoomableViewSingleTapped:(ZoomableImageView*)imageZoomableView inImage:(BOOL)inImage{
    if (!inImage) {
        [self dismiss:YES];
    }
}
@end
