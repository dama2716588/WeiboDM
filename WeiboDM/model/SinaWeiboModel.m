//
//  SinaWeiboModel.m
//  pento
//
//  Created by ma yulong on 13-5-2.
//  Copyright (c) 2013年 Pento. All rights reserved.
//

#import "SinaWeiboModel.h"

@implementation SinaWeiboModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    [super setValue:value forUndefinedKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"retweeted_status"]){
        if (value)
        _sinaRepost = [[SinaWeiboModel alloc] initWithDictionary:value];
    }
    
    else if ([key isEqualToString:@"text"]) {
        self.text = [self addTagA:value];
    }
        
    else if ([key isEqualToString:@"user"]) {
        _sinaUser = [[SinaUserModel alloc] initWithDictionary:value];
    } else {
        if ([key isEqualToString:@"id"]){
            self.weiboId = (int)value;
        } else {
            [super setValue:value forKey:key];
        }
    }
}

-(NSString *)addTagA:(NSString *)str
{
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern: @"(\\b(https?):\\/\\/[-A-Z0-9+&@#\\/%?=~_|!:,.;]*[-A-Z0-9+&@#\\/%=~_|])" options:NSRegularExpressionCaseInsensitive error:NULL];
    NSString *someString = str;
    
    NSArray *rangeArray = [expression matchesInString:someString options:NSMatchingReportCompletion range:NSMakeRange(0, [someString length])];
    
    for (NSTextCheckingResult *match in rangeArray)
    {
        NSRange range = [match rangeAtIndex:0];
        if (range.location == NSNotFound) {
            return str;
        }
        
        NSString *match = [someString substringWithRange:range];
        NSString *addAA = [NSString stringWithFormat:@"%@%@",match,@" "];
        str = [str stringByReplacingOccurrencesOfString:match withString:addAA];
    }
    
    return str;
}

@end
