//
//  AppDelegate.h
//  WeiboDM
//
//  Created by ma yulong on 13-5-24.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "OptionViewController.h"
#import "MainViewController.h"
#import "DMNavigationController.h"

@interface AppDelegate : UIResponder
<UIApplicationDelegate,
OptionViewControllerDelegate,
LoginViewControllerDelegate
>   

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DMNavigationController *navVC;
@property (strong, nonatomic) LoginViewController *loginVC;
@property (strong, nonatomic) OptionViewController *optionVC;
@property (strong, nonatomic) MainViewController *mainVC;

@end
