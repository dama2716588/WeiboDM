//
//  ImageLoadOperation.h
//  TMALL
//
//  Created by 诗彬 刘 on 12-2-2.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataCacheManager.h"
@protocol ImageLoadOperationDelegate;
@interface ImageLoadOperation : NSOperation{
    NSString *_imageUrl;
    id<ImageLoadOperationDelegate> _delegate;
    DataCacheType _cacheType;
}
@property (nonatomic,assign) id<ImageLoadOperationDelegate> delegate;
@property (nonatomic,copy) NSString *imageUrl;
- (id)initWithURL:(NSString *)url delegate:(id<ImageLoadOperationDelegate>)delegate cacheType:(DataCacheType)cacheType;
@end

@protocol ImageLoadOperationDelegate <NSObject>
-(void)imageDataOperation:(ImageLoadOperation*)operation loadedWithUrl:(NSString*)url withImage:(UIImage*)image;
@end
