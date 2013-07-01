//
//  DataCacheManager.m
//  TMALL
//
//  Created by 诗彬 刘 on 12-2-1.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import "DataCacheManager.h"
#import "SynthesizeSingleton.h"
#import "Helper.h"

#define USER_DEFAULT    [NSUserDefaults standardUserDefaults]

@interface DataCacheManager()
- (void)restore;
- (NSString *)savepath;
- (BOOL)isValidKey:(NSString*)key;
- (void)removeKey:(NSString*)key fromKeyArray:(NSMutableArray*)keyArray;
@end

@implementation DataCacheManager
SYNTHESIZE_SINGLETON_FOR_CLASS(DataCacheManager)

- (void)dealloc{
    [_memoryCacheKeys release];
    [_memoryCachedObjects release];
    [_cacheKeys release];
    [_cachedObjects release];
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (!sharedDataCacheManager) {
        sharedDataCacheManager = self;
    }
    if (sharedDataCacheManager) {
        [sharedDataCacheManager restore];
    }
    return sharedDataCacheManager;
}

#pragma mark - private methods
- (void)restore{
    if (_cacheKeys) {
        [_cacheKeys release];
        _cacheKeys = nil;
    }
    if (_cachedObjects) {
        [_cachedObjects release];
        _cachedObjects = nil;
    }
    if (_memoryCacheKeys) {
        [_memoryCacheKeys release];
        _memoryCacheKeys = nil;
    }
    if (_memoryCachedObjects) {
        [_memoryCachedObjects release];
        _memoryCachedObjects = nil;
    }
    @synchronized(self){
        NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:[self savepath]]; 
        if ([dataDic objectForKey:kDataCacheKeys]) {
            NSArray *keysArray = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:kDataCacheKeys]];
            _cacheKeys = [[NSMutableArray alloc] initWithArray:keysArray];
        }else{
            _cacheKeys = [[NSMutableArray alloc] init];
        }
        
        if([dataDic objectForKey:kDataCacheObjects]){
            NSDictionary *objDic = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:kDataCacheObjects]];
            _cachedObjects = [[NSMutableDictionary alloc] initWithDictionary:objDic];
        }else{
            _cachedObjects = [[NSMutableDictionary alloc] init];
        }
    }
    _memoryCacheKeys = [[NSMutableArray alloc] init];
    _memoryCachedObjects = [[NSMutableDictionary alloc] init];
}

- (NSString *)savepath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheFolder = [paths objectAtIndex:0];
    return [cacheFolder stringByAppendingPathComponent:@"cacheData"];
}

- (BOOL)isValidKey:(NSString*)key{
    if (!key || [key length] == 0 || (NSNull*)key == [NSNull null]) {
        return NO;
    }
    return YES;
}

- (void)removeKey:(NSString*)key fromKeyArray:(NSMutableArray*)keyArray{
    int indexInKeys = NSNotFound;
    for (int i=0;i < [keyArray count];i++) {
        if ([[keyArray objectAtIndex:i] isEqualToString:key]) {
            indexInKeys = i;
            break;
        }
    }
    if (indexInKeys != NSNotFound) {
        [keyArray removeObjectAtIndex:indexInKeys];
    }
}
#pragma mark - public methods
- (void)doSave{
    @synchronized(self){
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        [dataDic setObject:[NSKeyedArchiver archivedDataWithRootObject:_cacheKeys] forKey:kDataCacheKeys];
        [dataDic setObject:[NSKeyedArchiver archivedDataWithRootObject:_cachedObjects] forKey:kDataCacheObjects];
        [dataDic writeToFile:[self savepath] atomically:YES];
    }
}

- (void)clearAllCache{
    [self clearMemoryCache];
    [_cacheKeys removeAllObjects];
    [_cachedObjects removeAllObjects];
    [self doSave];
}

- (void)clearMemoryCache{
    [_memoryCacheKeys removeAllObjects];
    [_memoryCachedObjects removeAllObjects];
}

- (void)addObject:(NSObject*)obj forKey:(NSString*)key{
    if (![self isValidKey:key]) {
        return;
    }
    if (!obj || (NSNull*)obj == [NSNull null]) {
        [self removeObjectInCacheByKey:key];
        return;
    }
    if ([self hasObjectInCacheByKey:key]) {
        [self removeObjectInCacheByKey:key];
    }
    [_cacheKeys addObject:key];
    [_cachedObjects setObject:obj forKey:key];
    [self doSave];
}

- (void)addObjectToMemory:(NSObject*)obj forKey:(NSString*)key{
    if (![self isValidKey:key]) {
        return;
    }
    if (!obj || (NSNull*)obj == [NSNull null]) {
        return;
    }
    if ([self hasObjectInCacheByKey:key]) {
        [self removeObjectInCacheByKey:key];
    }
    [_memoryCacheKeys addObject:key];
    [_memoryCachedObjects setObject:obj forKey:key];
}

- (NSObject*)getCachedObjectByKey:(NSString*)key{
    if (![self isValidKey:key]) {
        return nil;
    }
    if ([_memoryCachedObjects objectForKey:key]) {
        return [_memoryCachedObjects objectForKey:key];
    }else{
        return [_cachedObjects objectForKey:key];
    }
}

- (BOOL)hasObjectInCacheByKey:(NSString*)key{
    return [self getCachedObjectByKey:key] != nil;
}

- (void)removeObjectInCacheByKey:(NSString*)key{
    if (![self isValidKey:key]) {
        return;
    }
    [_cachedObjects removeObjectForKey:key];
    [self removeKey:key fromKeyArray:_cacheKeys];
    [_memoryCachedObjects removeObjectForKey:key];
    [self removeKey:key fromKeyArray:_memoryCacheKeys];
}
@end
