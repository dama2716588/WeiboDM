//
//  ZoomableImageView.h
//  Created by 诗彬 刘 on 12-3-15.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//


#import "ZoomableImageView.h"

@interface ZoomableImageView()
- (BOOL)pointInImage:(CGPoint)point;
@end

@implementation ZoomableImageView
@synthesize index = _index;
@synthesize tapDelegate = _tapDelegate;

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        _canClickScale = YES;
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;        
        _imageView = [[GHGIFImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth 
        | UIViewAutoresizingFlexibleHeight;
//        | UIViewAutoresizingFlexibleTopMargin
//        | UIViewAutoresizingFlexibleRightMargin
//        | UIViewAutoresizingFlexibleLeftMargin
//        | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_imageView];
        [self setMaxMinZoomScalesForCurrentBounds];
    }
    return self;
}

- (void)dealloc{
    _tapDelegate = nil;
    [_imageView release];
    [super dealloc];
}

- (void)setImage:(id)image{
    if ([image isKindOfClass:[GHGifImage class]]) {
        [_imageView setGifImage:image];        
    }else{
        [_imageView setImage:image];
    }
    [self setMaxMinZoomScalesForCurrentBounds];
}

- (id)image{
    return _imageView.image;
}

#pragma mark - Override layoutSubviews to center content

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width){
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }else{
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height){
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }else{
        frameToCenter.origin.y = 0;
    }
    
    _imageView.frame = frameToCenter;
    
}

#pragma mark - UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

#pragma mark - Configure scrollView to display new image 


#pragma mark - Methods called during rotation to preserve the zoomScale and the visible portion of the image

// returns the center point, in image coordinate space, to try to restore after rotation. 
- (CGPoint)pointToCenterAfterRotation{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return [self convertPoint:boundsCenter toView:_imageView];
}

- (void)setMaxMinZoomScalesForCurrentBounds{
    if (!_imageView.image) {
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
    }
    UIImage *image = _imageView.image;
    CGFloat widthScale = image.size.width/_imageView.bounds.size.width;
    CGFloat heightScale = image.size.height/_imageView.bounds.size.height;
    self.maximumZoomScale = MAX(widthScale, heightScale);
    self.minimumZoomScale = 1;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setMaxMinZoomScalesForCurrentBounds];
}
// returns the zoom scale to attempt to restore after rotation. 
- (CGFloat)scaleToRestoreAfterRotation{
    CGFloat contentScale = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (contentScale <= self.minimumZoomScale + FLT_EPSILON){
        contentScale = 0;
    }    
    return contentScale;
}

- (CGPoint)maximumContentOffset{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset{
    return CGPointZero;
}

// Adjusts content offset and scale to try to preserve the old zoomscale and center.
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale{    
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
    
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:oldCenter fromView:_imageView];
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0, 
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
    offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
    self.contentOffset = offset;
}

- (BOOL)pointInImage:(CGPoint)point{
    CGSize imageSize = _imageView.image.size;
    CGSize viewSize = _imageView.frame.size;
    CGFloat imageScale = MIN(viewSize.width/imageSize.width, viewSize.height/imageSize.height);
    CGSize size = CGSizeApplyScale(imageSize, imageScale);
    CGRect imageFrame = CGRectMakeWithCenterAndSize(_imageView.centerOfView, size);
    return CGRectContainsPoint(imageFrame, point);
}
#pragma mark - handle double tap and single tap

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];

    NSUInteger tapCount = [touch tapCount];
    switch (tapCount) {
        case 1:
            [self performSelector:@selector(singleTapBegan:) withObject:[NSArray arrayWithObjects:touches, event,nil] afterDelay:.3];
            break;
        case 2:
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            break;
        default:
            break;
    }
}

- (void)singleTapBegan:(NSArray *)sender{
    [[self nextResponder] touchesBegan:[sender objectAtIndex:0] withEvent:[sender objectAtIndex:1]];
}

-(void)singleTapEnd:(NSArray *)sender{
    [[self nextResponder] touchesEnded:[sender objectAtIndex:0] withEvent:[sender objectAtIndex:1]];
    UITouch *touch = [[sender objectAtIndex:0] anyObject];
    CGPoint point = [touch locationInView:_imageView];
    point = CGPointApplyAffineTransform(point, CGAffineTransformMakeScale(self.zoomScale, self.zoomScale));
    
    if (_tapDelegate && [_tapDelegate respondsToSelector:@selector(imageZoomableViewSingleTapped:inImage:) ]) {
        [_tapDelegate imageZoomableViewSingleTapped:self inImage:[self pointInImage:point]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    NSUInteger tapCount = [touch tapCount];
    if(tapCount == 2){
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        if (self.zoomScale != self.minimumZoomScale) {
            CGFloat scaleTime = (self.zoomScale - self.minimumZoomScale)/self.zoomScale/2;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:scaleTime];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.zoomScale = self.minimumZoomScale;
            
            [UIView commitAnimations];
        }else{
            if (!_canClickScale) {
                return;
            }
            UITouch *touch = [touches anyObject];
            CGPoint centerPoint = [touch locationInView:self];
            CGPoint origin = self.contentOffset;
            centerPoint = CGPointMake(centerPoint.x - origin.x, centerPoint.y - origin.y);

            [self setZoomScale:self.maximumZoomScale animated:YES];
            [self setContentOffset:CGPointMake((self.maximumZoomScale - 1)*centerPoint.x, (self.maximumZoomScale - 1)*centerPoint.y) animated:YES];
        }
    }else if(tapCount == 1){
        
        [self performSelector:@selector(singleTapEnd:) withObject:[NSArray arrayWithObjects:touches, event,nil] afterDelay:.3];
    }
}
@end
