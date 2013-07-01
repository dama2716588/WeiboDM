//
//  SinaCommentsModel.h
//  pento
//
//  Created by ma yulong on 13-5-13.
//  Copyright (c) 2013年 Pento. All rights reserved.
//

#import "BaseModel.h"
#import "SinaUserModel.h"
#import "SinaWeiboModel.h"

@interface SinaCommentsModel : BaseModel

@property (nonatomic, strong) SinaUserModel *sinaUser;
@property (nonatomic, strong) SinaWeiboModel *sinaWeibo;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) SinaCommentsModel *replyComment;

@end
