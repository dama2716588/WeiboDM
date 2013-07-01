//
//  LoginViewController.h
//  WeiboDM
//
//  Created by ma yulong on 13-5-24.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PTSinaWeiboClient.h"

@protocol LoginViewControllerDelegate <NSObject>
- (void)loginViewControllerDone;
@end

@interface LoginViewController : BaseViewController<SinaWeiboDelegate>

@property(strong, nonatomic) UIButton *btnSinaLogin;
@property(strong, nonatomic) UIButton *btnLookAround;
@property(weak, nonatomic) id <LoginViewControllerDelegate> delegate;
@property(strong, nonatomic) PTSinaWeiboClient *sinaWeiboClient;
- (void)gotoRegisterState;
@end