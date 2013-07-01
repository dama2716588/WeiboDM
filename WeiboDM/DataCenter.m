//
//  DataCenter.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-14.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "DataCenter.h"

@implementation DataCenter
{
    NSArray *_sinaWeiboTypeList;
}

#pragma mark Singleton
+ (DataCenter *)sharedDataCenter {
    static DataCenter *sSingleton = nil;
    if (sSingleton == nil) {
        sSingleton = [[DataCenter alloc] initSingleton];
    }
    return sSingleton;
}

// Real init method
- (id)initSingleton {
    self = [super init];
    if ((self = [super init])) {
        [self initMenuArray];
    }
    return self;
}

- (void)initMenuArray {    
    SinaWeiboType *all = [[SinaWeiboType alloc] initWithTitle:SINA_WEIBO_TYPE_ALL_NAME type:SINA_WEIBO_TYPE_ALL id:nil];
    SinaWeiboType *image = [[SinaWeiboType alloc] initWithTitle:SINA_WEIBO_TYPE_PIC_NAME type:SINA_WEIBO_TYPE_IMAGE id:nil];
    SinaWeiboType *origin = [[SinaWeiboType alloc] initWithTitle:SINA_WEIBO_TYPE_ORIGIN_NAME type:SINA_WEIBO_TYPE_ORIGIN id:nil];
    SinaWeiboType *vedio = [[SinaWeiboType alloc] initWithTitle:SINA_WEIBO_TYPE_VIDEO_NAME type:SINA_WEIBO_TYPE_VEIDO id:nil];
    SinaWeiboType *music = [[SinaWeiboType alloc] initWithTitle:SINA_WEIBO_TYPE_MUSIC_NAME type:SINA_WEIBO_TYPE_MUSIC id:nil];
    SinaWeiboType *atme = [[SinaWeiboType alloc] initWithTitle:SINA_WEIBO_TYPE_ATME_NAME type:SINA_WEIBO_TYPE_ATME id:nil];
    _sinaWeiboTypeList = @[all, image, origin, vedio, music, atme];    
}


-(NSArray *)getSinaWeiboTypeList
{
    return _sinaWeiboTypeList;
}

@end

