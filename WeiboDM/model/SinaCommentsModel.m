//
//  SinaCommentsModel.m
//  pento
//
//  Created by ma yulong on 13-5-13.
//  Copyright (c) 2013年 Pento. All rights reserved.
//

#import "SinaCommentsModel.h"

@implementation SinaCommentsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    [super setValue:value forUndefinedKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"user"]) {
        self.sinaUser = [[SinaUserModel alloc] initWithDictionary:value];
    } else if ([key isEqualToString:@"status"]){
        self.sinaWeibo = [[SinaWeiboModel alloc] initWithDictionary:value];
    } else if ([key isEqualToString:@"reply_comment"]){
        self.replyComment = [[SinaCommentsModel alloc] initWithDictionary:value];
    } else {
        [super setValue:value forKey:key];
    }
}

@end
