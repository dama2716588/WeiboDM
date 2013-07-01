//
//  ImageLoadOperation.m
//  TMALL
//
//  Created by 诗彬 刘 on 12-2-2.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import "ImageLoadOperation.h"
#import "ImageCacheManager.h"

@implementation ImageLoadOperation
@synthesize delegate = _delegate;
@synthesize imageUrl = _imageUrl;
- (void)dealloc {
    [self cancel];
    [_imageUrl release];
	[super dealloc];
}

- (id)initWithURL:(NSString *)aUrl delegate:(id<ImageLoadOperationDelegate>)aDelegate cacheType:(DataCacheType)cacheType{
    self = [self init];
	if (self) {
		self.imageUrl =aUrl;
		self.delegate =aDelegate;
        _cacheType = cacheType;
	}
	return self;
}

- (void)main{
    UIImage *image = nil;
    if (_cacheType&DataCacheTypePersist) {
        image = [[ImageCacheManager sharedImageCacheManager] getImageFromCacheWithUrl:_imageUrl];
    }
	if(!image){
		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
		if(imageData!=nil){
			image = [UIImage imageWithData:imageData];
		}
	}
    if (image && _delegate && [_delegate respondsToSelector:@selector(imageDataOperation:loadedWithUrl:withImage:)]) {
        dispatch_async(dispatch_get_main_queue(),^{
            [_delegate imageDataOperation:self 
                            loadedWithUrl:_imageUrl
                                withImage:image];
        });
    }
}
@end
