//
//  SinaWeiboType.m
//  pento
//
//  Created by ma yulong on 13-5-1.
//  Copyright (c) 2013年 Pento. All rights reserved.
//

#import "SinaWeiboType.h"

@implementation SinaWeiboType

- (id)initWithTitle:(NSString *)title type:(NSString *)type id:(NSString *)typeId
{
    if (self = [super init]) {
        self.title = title;
        self.type = type;
        self.typeId = typeId;
    }
    return self;    
}

@end
