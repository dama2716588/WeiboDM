//
//  FriendViewController.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-14.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSinaWeiboClient.h"

@interface FriendViewController : UIViewController <SinaWeiboDelegate,SinaWeiboRequestDelegate,UITableViewDelegate,UITableViewDataSource>

- (id)initWithFriendType:(NSString *)type;

@end
