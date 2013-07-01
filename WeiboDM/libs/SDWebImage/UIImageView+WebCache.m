/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "objc/runtime.h"

static char operationKey;

//static dispatch_queue_t staticRoundImageQueue;

@implementation UIImageView (WebCache)

//+ (dispatch_queue_t)roundImageQueue {
//        if (staticRoundImageQueue == nil) {
//            staticRoundImageQueue = dispatch_queue_create(@"roundImageQueue", NULL);
//        }
//    
//    return staticRoundImageQueue;
//}

- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder round:(BOOL)round {
    [self setImageWithURL:url placeholderImage:placeholder options:SDWebImageRoundImage progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock {
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock {
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock {
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

-(UIImage*)imageCrop:(UIImage*)original
{
    UIImage *ret = nil;
    
    // This calculates the crop area.
    
    float originalWidth  = original.size.width;
    float originalHeight = original.size.height;
    
    float edge = fminf(originalWidth, originalHeight);
    
    float posX = (originalWidth   - edge) / 2.0f;
    float posY = (originalHeight  - edge) / 2.0f;
    
    
    CGRect cropSquare = CGRectMake(posX, posY,
                                   edge, edge);
    
    
    // This performs the image cropping.
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([original CGImage], cropSquare);
    
    ret = [UIImage imageWithCGImage:imageRef
                              scale:original.scale
                        orientation:original.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return ret;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock; {
    [self cancelCurrentImageLoad];

    self.image = placeholder;

    if (url) {
        __weak UIImageView *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            __strong UIImageView *sself = wself;
            if (!sself) return;
            if (image) {
                if (options & SDWebImageRoundImage) {
                    UIImage *cropedImage = [self imageCrop:image];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
                        // start with an image
                        CGRect imageRect = CGRectMake(0, 0, cropedImage.size.width, cropedImage.size.height);
                        // set the implicit graphics context ("canvas") to a bitmap context for images
                        UIGraphicsBeginImageContextWithOptions(imageRect.size,NO,0.0);
                        // create a bezier path defining rounded corners
                        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:cropedImage.size.width / 2];
                        // use this path for clipping in the implicit context
                        [path addClip];
                        // draw the image into the implicit context
                        [cropedImage drawInRect:imageRect];
                        // save the clipped image from the implicit context into an image
                        UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
                        // cleanup
                        UIGraphicsEndImageContext();
                        
                        dispatch_async(dispatch_get_main_queue(), ^() {
                            sself.image = maskedImage;
                            [sself setNeedsLayout];
                        });
                    });
                } else {
                    sself.image = image;
                    [sself setNeedsLayout];                    
                }
                
            }
            if (completedBlock && finished) {
                completedBlock(image, error, cacheType);
            }
        }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)cancelCurrentImageLoad {
    // Cancel in progress downloader from queue
    id <SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation) {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
