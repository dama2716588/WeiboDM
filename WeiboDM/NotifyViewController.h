//
//  NotifyViewController.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-12.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "PTSinaWeiboClient.h"

@interface NotifyViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,SinaWeiboDelegate,SinaWeiboRequestDelegate>

- (id)initWithNotify:(NSDictionary *)dic;

@end
