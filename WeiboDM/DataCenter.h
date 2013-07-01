//
//  DataCenter.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-14.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaWeiboType.h"

@interface DataCenter : NSObject

+ (DataCenter *)sharedDataCenter;
- (NSArray *)getSinaWeiboTypeList;

@end
