//
//  Helper.h
//  WeiboDM
//
//  Created by ma yulong on 13-5-26.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class UIView;
@class NSString;
@class UIColor;

typedef void (^FunctionBlock)(id);

@interface Helper : NSObject
+ (UIColor *)createRandomColor;

+ (NSString *)getPinTimeString:(NSString *)dateString;

+ (NSString *)documentDir;
+ (NSString *)cacheDir;
+ (NSString *)documentFileWithName:(NSString *)name;
+ (NSString *)cacheFileWithName:(NSString *)name;

+ (void)dispatchOnMainThread:(dispatch_block_t)block;
+ (NSString *)downloadFile:(NSString *)url;
+ (UIImage *)downloadImage:(NSString *)url;
+ (UIImage *)snapshotOfView:(UIView *)view;
@end