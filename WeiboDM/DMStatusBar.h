//
//  DMStatusBar.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-18.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GET_UNREAD_WEIBO;

@interface DMStatusBar : UIWindow
{
    UILabel *_textLabel;
    UIButton *_statusButton;
}

- (void)showStatusMessage:(NSString *)message;
- (void)hide;

@end
