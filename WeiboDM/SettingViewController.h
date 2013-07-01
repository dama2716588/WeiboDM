//
//  SettingViewController.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-8.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "BaseViewController.h"
#import "PTSinaWeiboClient.h"
#import "LoginViewController.h"

@interface SettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SinaWeiboDelegate,LoginViewControllerDelegate>

@end
