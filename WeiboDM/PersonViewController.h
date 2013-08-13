//
//  PersonViewController.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-16.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSinaWeiboClient.h"
#import "SinaUserModel.h"
#import "PersonCell.h"

@interface PersonViewController : UIViewController <SinaWeiboDelegate,SinaWeiboRequestDelegate,UITableViewDataSource,UITableViewDelegate>

- (id)initWithSinaUserModel:(SinaUserModel *)sinaUser;

@end
