//
//  WeiboDetailViewController.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-11.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "BaseViewController.h"
#import "SinaWeiboModel.h"
#import "OHAttributedLabel.h"
#import "PTSinaWeiboClient.h"
#import "WeiboCommentCell.h"

@interface WeiboDetailViewController : UIViewController <OHAttributedLabelDelegate,UITableViewDataSource,UITableViewDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,WeiboCommentCellDelegate>

- (id)initWithSinaWeiboModel:(SinaWeiboModel *)model;

@end
