//
//  CommentViewController.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-13.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSinaWeiboClient.h"
#import "BaseViewController.h"

@interface CommentViewController : UIViewController <SinaWeiboDelegate,SinaWeiboRequestDelegate,UITableViewDataSource,UITableViewDelegate>

@end
