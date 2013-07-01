//
//  ImageCacheManager.m
//  TMALL
//
//  Created by 诗彬 刘 on 12-2-2.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import "ImageCacheManager.h"
#import "SynthesizeSingleton.h"

@interface ImageCacheManager()
- (NSString*)encodeURL:(NSString *)string;
- (NSString*)getKeyFromUrl:(NSString*)url;
- (NSString*)getPathByFileName:(NSString *)fileName;
- (void)saveToMemory:(UIImage*)image forKey:(NSString*)key;
- (UIImage*)getImageFromMemoryCache:(NSString*)key;
- (BOOL)isImageInMemoryCache:(NSString*)key;
- (NSString *)getImageFolder;
- (BOOL)createDirectorysAtPath:(NSString *)path;
- (void)checkRequestQueueStatus;
@end


@implementation ImageCacheManager
SYNTHESIZE_SINGLETON_FOR_CLASS(ImageCacheManager);
@synthesize imageQueue = _imageQueue;

- (void)restore{
    [_observers release];
    _observers = nil;
    [_imageQueue release];
    _imageQueue = [[NSOperationQueue alloc] init];
    [_imageQueue setMaxConcurrentOperationCount:20];
    [_memoryCache release];
    _memoryCache = [[NSMutableDictionary alloc] init];
    NSString *path = [self getImageFolder];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self createDirectorysAtPath:path];
    }
}

- (id)init{
    self = [super init];
	if (!sharedImageCacheManager) {
		sharedImageCacheManager = self;
	}
    if(sharedImageCacheManager) {
		[sharedImageCacheManager restore];
        [NSTimer scheduledTimerWithTimeInterval:10.0f 
                                         target:sharedImageCacheManager
                                       selector:@selector(checkRequestQueueStatus) 
                                       userInfo:nil
                                        repeats:YES];
	}
	return sharedImageCacheManager;
}

- (void)dealloc{
    [_observers release];
    [_memoryCache release];
    [_imageQueue release];
    [_lastSuspendedTime release];
    [super dealloc];
}

#pragma mark - private methods
- (NSString*)encodeURL:(NSString *)string{
	NSString *newString = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease];
	if (newString) {
		return newString;
	}
	return @"";
}

- (BOOL)createDirectorysAtPath:(NSString *)path{
    @synchronized(self){
        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:path]) {
            NSError *error = nil;
            if (![manager createDirectoryAtPath:path 
                    withIntermediateDirectories:YES 
                                     attributes:nil 
                                          error:&error]) {
                return NO;
            }
        }
    }
    return YES;
}

- (NSString *)getImageFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheFolder = [paths objectAtIndex:0];
	return [NSString stringWithFormat:@"%@/images",cacheFolder];
}

- (NSString *)getPathByFileName:(NSString *)fileName{
    return [[self getImageFolder] stringByAppendingPathComponent:fileName];
	return [NSString stringWithFormat:@"%@/%@",[self getImageFolder],fileName];
}

- (NSString*)getKeyFromUrl:(NSString*)url{
    return [self encodeURL:url];
}

- (void)saveToMemory:(UIImage*)image forKey:(NSString*)key{
    if (image) {
        [_memoryCache setObject:image forKey:key];
    }
}

- (UIImage*)getImageFromMemoryCache:(NSString*)key{
    return [_memoryCache objectForKey:key];
}

- (BOOL)isImageInMemoryCacheWithUrl:(NSString*)url{
    return [self isImageInMemoryCache:[self getKeyFromUrl:url]];
}

- (BOOL)isImageInMemoryCache:(NSString*)key{
    return (nil != [self getImageFromMemoryCache:key]);
}
// make sure queue will not suspended for too long
- (void)checkRequestQueueStatus{
    if(!_lastSuspendedTime || [_imageQueue operationCount] == 0 ){
        return;
    }
    if ([[NSDate date] timeIntervalSinceDate:_lastSuspendedTime] > 5.0) {
        [self restoreImageLoading];
    }
}
#pragma mark - public methods
- (BOOL)isLoadingImage:(NSString *)imageUrl{
    for (ImageLoadOperation *operation in _imageQueue.operations) {
        if ([operation.imageUrl isEqualToString:imageUrl]) {
            return YES;
        }
    }
    return NO;
}

- (ImageLoadOperation *)operationForImage:(NSString *)imageUrl{
    for (ImageLoadOperation *operation in _imageQueue.operations) {
        if ([operation.imageUrl isEqualToString:imageUrl]) {
            return operation;
        }
    }
    return nil;
}

- (void)cancelLoadImage:(NSString *)imageUrl{
    [[self operationForImage:imageUrl] cancel];
    [_observers removeObjectForKey:imageUrl];
}

- (void)addObserver:(NSObject<ImageLoadDelegate>*)delegate forUrl:(NSString *)imageUrl{
    NSMutableArray *array = [_observers objectForKey:imageUrl];
    if (!array) {
        array = [NSMutableArray arrayWithObject:delegate];
        [_observers setObject:array forKey:imageUrl];
    }else{
        [array addObject:delegate];
    }
}

- (void)removeObserver:(NSObject<ImageLoadDelegate> *)observer forUrl:(NSString *)imageUrl{
    NSMutableArray *array = [_observers objectForKey:imageUrl];
    if (array!=nil) {
        [array removeObject:observer];
        if (array.count==0) {
            [self cancelLoadImage:imageUrl];
        }
    }
}

- (void)loadImageWithDelegate:(NSObject<ImageLoadDelegate> *)delegate url:(NSString *)imageUrl{
    if (!imageUrl||imageUrl.length<=0) {
        return;
    }
    if (!_observers) {
        _observers = [[NSMutableDictionary alloc] init];
    }
    UIImage *image = [self getImageFromCacheWithUrl:imageUrl];
    if (image) {
        [delegate imageDidLoad:image url:imageUrl usingCache:YES];
    }else if([self isLoadingImage:imageUrl]){
        [self addObserver:delegate forUrl:imageUrl];
    }else{
        ImageLoadOperation *imageOperation = [[ImageLoadOperation alloc] initWithURL:imageUrl 
                                                                            delegate:self 
                                                                           cacheType:DataCacheTypePersist];
        
        [_imageQueue addOperation:imageOperation];
        [imageOperation release];
        [self addObserver:delegate forUrl:imageUrl];
    }
}

- (void)loadImageWithUrl:(NSString *)imageUrl{
    [self loadImageWithDelegate:self url:imageUrl];
}

- (void)saveImage:(UIImage*)image withUrl:(NSString*)url{
    [self saveImage:image withKey:[self getKeyFromUrl:url]];
}

- (void)saveImage:(UIImage*)image withKey:(NSString*)key{
    @synchronized(self){
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSData* imageData = UIImagePNGRepresentation(image);
        NSString *imageFilePath = [self getPathByFileName:key];
        [imageData writeToFile:imageFilePath atomically:YES];
        [self saveToMemory:image forKey:key];
        [pool release];
    }
}

- (UIImage*)getImageFromCacheWithUrl:(NSString*)url{
    return [self getImageFromCacheWithKey:[self getKeyFromUrl:url]];
}

- (UIImage*)getImageFromCacheWithKey:(NSString*)key{
    if ([self isImageInMemoryCache:key]) {
        return [self getImageFromMemoryCache:key];
    }else{
        NSString *imageFilePath = [self getPathByFileName:key];
        UIImage* image = [UIImage imageWithContentsOfFile:imageFilePath];
        if (image) {
            [self saveToMemory:image forKey:key];
        }
        return image;
    }
}

- (void)clearDiskCache{
    NSString *imageFolderPath = [self getImageFolder];
    [[NSFileManager defaultManager] removeItemAtPath:imageFolderPath error:nil];
    [self createDirectorysAtPath:imageFolderPath];
}

- (void)clearMemoryCache{
    [_memoryCache release];
    _memoryCache = [[NSMutableDictionary alloc] init];
}

- (void)suspendImageLoading{
    if ([_imageQueue isSuspended]) {
        return;
    }
    [_imageQueue setSuspended:YES];
    [_lastSuspendedTime release];
    _lastSuspendedTime = [[NSDate date] retain];
}

- (void)restoreImageLoading{
    [_imageQueue setSuspended:NO];
    [_lastSuspendedTime release];
    _lastSuspendedTime = nil;
}

-(void)imageDidLoad:(UIImage *)image url:(NSString *)url usingCache:(BOOL)isCache{

}

-(void)imageDataOperation:(ImageLoadOperation*)operation loadedWithUrl:(NSString*)url withImage:(UIImage*)image{
    [self saveImage:image withUrl:url];
    NSArray *observers = [NSArray arrayWithArray:[_observers objectForKey:url]];
    if (observers) {
        for (NSObject<ImageLoadDelegate> *obsever in observers) {
            [obsever imageDidLoad:image url:url usingCache:NO];
        }
        [_observers removeObjectForKey:url];
    }
}
@end
