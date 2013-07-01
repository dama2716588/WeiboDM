//
//  OptionViewController.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-7.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "BaseViewController.h"

@protocol OptionViewControllerDelegate <NSObject>
- (void)navigateToLoginStateView;
- (void)navigateToRegisterStateView;
- (void)navigateToMainStateView;
@end

@interface OptionViewController : BaseViewController
@property (nonatomic,assign) id<OptionViewControllerDelegate> delegate;
@end
