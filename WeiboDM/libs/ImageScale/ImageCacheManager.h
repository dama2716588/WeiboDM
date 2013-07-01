//
//  ImageCacheManager.h
//  TMALL
//
//  Created by 诗彬 刘 on 12-2-2.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageLoadOperation.h"
@class ImageCacheManager;
@protocol  ImageLoadDelegate<NSObject>
-(void)imageDidLoad:(UIImage *)image url:(NSString *)url usingCache:(BOOL)isCache;
@end

@interface ImageCacheManager : NSObject<ImageLoadOperationDelegate,ImageLoadDelegate>{
	NSOperationQueue *_imageQueue;
    NSMutableDictionary *_memoryCache;
    NSMutableDictionary *_observers;
    NSDate *_lastSuspendedTime;
}
@property (nonatomic,retain) NSOperationQueue *imageQueue;
+ (ImageCacheManager *)sharedImageCacheManager;

- (void)loadImageWithDelegate:(NSObject<ImageLoadDelegate>*)delegate url:(NSString *)imageUrl;
- (void)loadImageWithUrl:(NSString *)imageUrl;

- (void)addObserver:(NSObject<ImageLoadDelegate>*)delegate forUrl:(NSString *)imageUrl;
- (void)removeObserver:(NSObject<ImageLoadDelegate> *)observer forUrl:(NSString *)imageUrl;
- (BOOL)isLoadingImage:(NSString *)imageUrl;
- (ImageLoadOperation *)operationForImage:(NSString *)imageUrl;
- (void)cancelLoadImage:(NSString *)imageUrl;

- (void)clearMemoryCache;
- (void)clearDiskCache;
- (void)restore;
- (void)saveImage:(UIImage*)image withUrl:(NSString*)url;
- (void)saveImage:(UIImage*)image withKey:(NSString*)key;
- (UIImage*)getImageFromCacheWithUrl:(NSString*)url;
- (UIImage*)getImageFromCacheWithKey:(NSString*)key;
- (BOOL)isImageInMemoryCacheWithUrl:(NSString*)url;
- (void)suspendImageLoading;
- (void)restoreImageLoading;
@end
