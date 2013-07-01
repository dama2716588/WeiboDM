//
//  SCGIFImageView.h
//
//  Modified and BugFix by 诗彬 刘 from https://github.com/kasatani/AnimatedGifExample on 12-3-15
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//  
//

#import <UIKit/UIKit.h>

@interface GHGifImage : NSObject{
    UIImage *_thumbImage;
    UIImage *_image;
    NSArray *_images;
    float _animatedDelay;
}
@property(nonatomic,retain,readonly)NSArray *images;
@property(nonatomic,retain,readonly)UIImage *thumbImage;
@property(nonatomic,retain,readonly)UIImage *image;
@property(nonatomic,readonly)float animatedDelay;
+ (BOOL)isGifImage:(NSData*)imageData;
+ (GHGifImage *)gifImageWithData:(NSData *)data;
- (id)initWithData:(NSData *)data;
- (UIImage*)ImageAtIndex:(int)index;
@end

@interface GHGIFImageView : UIImageView {
    GHGifImage *_gifImage;
}
@property(nonatomic,retain)GHGifImage *gifImage;
- (id)initWithGIFFile:(NSString*)gifFilePath;
- (id)initWithGIFData:(NSData*)gifImageData;
@end
