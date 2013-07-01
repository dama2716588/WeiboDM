//
//  NSObject+Blocks.h
//  tvcast
//
//  Created by ZHA ZHA on 12-2-26.
//  Copyright (c) 2012年 iFun Info. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Additions)

- (void)performBlock:(void (^)(void))block;
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)afterDelay;
- (void)performBlockOnMainThread:(void (^)(void))block waitUntilDone:(BOOL)waitUntilDone;
- (void)setAssociatedObject:(id)object forKey:(NSString *)key;
- (id)getAssociatedObjectForKey:(NSString *)key;

@end
