//
//  NSObject+Blocks.m
//  tvcast
//
//  Created by ZHA ZHA on 12-2-26.
//  Copyright (c) 2012年 iFun Info. All rights reserved.
//

#import "NSObject+Additions.h"
#import <objc/runtime.h>


@implementation NSObject (Additions)

#pragma performBlock
- (void)performBlock:(void (^)(void))block {
    block = [block copy];
    [self performSelector:@selector(block:) withObject:block];
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)afterDelay {
    block = [block copy];
    [self performSelector:@selector(block:) withObject:block afterDelay:afterDelay];
}

- (void)performBlockOnMainThread:(void (^)(void))block waitUntilDone:(BOOL)waitUntilDone {
    block = [block copy];
    [self performSelectorOnMainThread:@selector(block:) withObject:block waitUntilDone:waitUntilDone];    
}

- (void)block:(void (^)(void))block {
    block();
}

#pragma associatedObject
- (void)setAssociatedObject:(id)object forKey:(NSString *)key {
    objc_setAssociatedObject(self, (__bridge const void *)(key), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)getAssociatedObjectForKey:(NSString *)key {
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

@end
