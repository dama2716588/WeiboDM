//
//  DataCacheManager.h
//  TMALL
//
//  Created by 诗彬 刘 on 12-2-1.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDataCacheKeys      @"kDataCacheKeys"
#define kDataCacheObjects   @"kDataCacheObjects"

typedef enum{
    DataCacheTypeNone = 0,
	DataCacheTypeMemory = 1<<1,
    DataCacheTypeDisk = 1<<2,
	DataCacheTypePersist = DataCacheTypeMemory|DataCacheTypeDisk
} DataCacheType;

@interface DataCacheManager : NSObject {
    NSMutableArray *_memoryCacheKeys;     
    NSMutableDictionary *_memoryCachedObjects;
    NSMutableArray *_cacheKeys;          
    NSMutableDictionary *_cachedObjects;
}
+ (DataCacheManager *)sharedDataCacheManager;
- (void)clearAllCache;
- (void)clearMemoryCache;
- (void)addObject:(NSObject*)obj forKey:(NSString*)key;
- (void)addObjectToMemory:(NSObject*)obj forKey:(NSString*)key;
- (NSObject*)getCachedObjectByKey:(NSString*)key;
- (BOOL)hasObjectInCacheByKey:(NSString*)key;
- (void)removeObjectInCacheByKey:(NSString*)key;
- (void)doSave;
@end