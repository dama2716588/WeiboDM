//
//  BrowserViewController.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-8.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "BaseViewController.h"

@interface BrowserViewController : BaseViewController <UITextFieldDelegate, UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSString *url;

- (id)initWithURL:(NSString *)url;
+ (void)openWithURL:(NSString *)url viewController:(UIViewController *)viewController;
@end
