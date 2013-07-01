//
//  ToAWeiboViewController.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-19.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeiboModel.h"
#import "PTSinaWeiboClient.h"

typedef enum ResponseWeiboType {
    CommentType,
    RepostType,
} ResponseWeiboType;

@interface ToAWeiboViewController : UIViewController <SinaWeiboDelegate,SinaWeiboRequestDelegate,UITextViewDelegate>

- (id)initWithType:(ResponseWeiboType)type andModel:(SinaWeiboModel *)model;

@end
