//
//  DMChecking.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-11.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTSinaWeiboClient.h"

extern NSString *const CHECKING_UNREAD_COUNT;

@interface DMChecking : NSObject <SinaWeiboDelegate,SinaWeiboRequestDelegate>

+ (DMChecking *)sharedDMChecking;
- (void)start;
- (void)stop;

@end
