//
//  SinaWeiboModel.h
//  pento
//
//  Created by ma yulong on 13-5-2.
//  Copyright (c) 2013年 Pento. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "SinaUserModel.h"

@class SinaUserModel;

@interface SinaWeiboModel : BaseModel

@property(nonatomic, assign) int weiboId;              //id
@property(nonatomic, copy) NSString *mid;              //mid
@property(nonatomic, assign) int comments_count;       //评论数
@property(nonatomic, assign) int reposts_count;        //转发数
@property(nonatomic, strong) NSString *thumbnail_pic;  //小图url
@property(nonatomic, strong) NSString *bmiddle_pic;    //中图url
@property(nonatomic, strong) NSString *original_pic;   //原图url
@property(nonatomic, strong) NSString *text;           //内容
@property(nonatomic, strong) SinaUserModel *sinaUser;
@property(nonatomic, strong) SinaWeiboModel *sinaRepost;
@property(nonatomic, strong) NSArray *pic_urls;

@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSString *image_url;
@property(nonatomic, assign) float image_height;
@property(nonatomic, assign) float image_width;
@property(nonatomic, assign) int repin_count;
@property(nonatomic, strong) NSString *short_content;
@property(nonatomic, strong) NSString *content_id;


@end
