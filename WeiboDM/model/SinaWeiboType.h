//
//  SinaWeiboType.h
//  pento
//
//  Created by ma yulong on 13-5-1.
//  Copyright (c) 2013年 Pento. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SINA_WEIBO_TYPE_ALL           @"0"
#define SINA_WEIBO_TYPE_IMAGE         @"1"
#define SINA_WEIBO_TYPE_ORIGIN        @"2"
#define SINA_WEIBO_TYPE_VEIDO         @"3"
#define SINA_WEIBO_TYPE_MUSIC         @"4"
#define SINA_WEIBO_TYPE_ATME          @"atme"

#define SINA_WEIBO_TYPE_ALL_NAME    @"全部"
#define SINA_WEIBO_TYPE_PIC_NAME    @"图片"
#define SINA_WEIBO_TYPE_ORIGIN_NAME @"原创"
#define SINA_WEIBO_TYPE_VIDEO_NAME  @"视频"
#define SINA_WEIBO_TYPE_MUSIC_NAME  @"音乐"
#define SINA_WEIBO_TYPE_ATME_NAME   @"我的"

@interface SinaWeiboType : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *typeId;

- (id)initWithTitle:(NSString *)title type:(NSString *)type id:(NSString *)typeId;

@end
